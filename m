Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8037C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 22:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiDGXAI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 19:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiDGXAH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 19:00:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83B81D4C09
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 15:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AF4860C54
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 22:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEE1C385AA;
        Thu,  7 Apr 2022 22:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649372284;
        bh=/+83rQyApgkh64qGV3CRRmdQ4uyKFyaLfTV9/POiDlc=;
        h=Date:To:From:Subject:From;
        b=lGFWkik1imHELVFiUzH5F38Fwn7ozjEiKjWsPpjyAbDGB8zZrnliB6kcSg3h9uiPo
         +dioS0s51tgkUfwcyPtp9LoaaOshnm7oKaXXxo3YDIStvmTjFhFtlBwISqb0KYJEz+
         Bbuw6xL58PW38tXgTfgaV8gOkaS2Kf42ZlcyCBuk=
Date:   Thu, 07 Apr 2022 15:58:03 -0700
To:     mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
        tj@kernel.org, songmuchun@bytedance.com, ming.lei@redhat.com,
        dennis@kernel.org, cl@linux.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu_ref-call-wake_up_all-after-percpu_ref_put-completes.patch added to -mm tree
Message-Id: <20220407225804.8FEE1C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu_ref: call wake_up_all() after percpu_ref_put() completes
has been added to the -mm tree.  Its filename is
     percpu_ref-call-wake_up_all-after-percpu_ref_put-completes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/percpu_ref-call-wake_up_all-after-percpu_ref_put-completes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/percpu_ref-call-wake_up_all-after-percpu_ref_put-completes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: percpu_ref: call wake_up_all() after percpu_ref_put() completes

In the percpu_ref_call_confirm_rcu(), we call the wake_up_all() before
calling percpu_ref_put(), which will cause the value of percpu_ref to be
unstable when percpu_ref_switch_to_atomic_sync() returns.

	CPU0				CPU1

percpu_ref_switch_to_atomic_sync(&ref)
--> percpu_ref_switch_to_atomic(&ref)
    --> percpu_ref_get(ref);	/* put after confirmation */
	call_rcu(&ref->data->rcu, percpu_ref_switch_to_atomic_rcu);

					percpu_ref_switch_to_atomic_rcu
					--> percpu_ref_call_confirm_rcu
					    --> data->confirm_switch = NULL;
						wake_up_all(&percpu_ref_switch_waitq);

    /* here waiting to wake up */
    wait_event(percpu_ref_switch_waitq, !ref->data->confirm_switch);
						(A)percpu_ref_put(ref);
/* The value of &ref is unstable! */
percpu_ref_is_zero(&ref)
						(B)percpu_ref_put(ref);

As shown above, assuming that the counts on each cpu add up to 0 before
calling percpu_ref_switch_to_atomic_sync(), we expect that after switching
to atomic mode, percpu_ref_is_zero() can return true.  But actually it
will return different values in the two cases of A and B, which is not
what we expected.

Maybe the original purpose of percpu_ref_switch_to_atomic_sync() is just
to ensure that the conversion to atomic mode is completed, but it should
not return with an extra reference count.

Calling wake_up_all() after percpu_ref_put() ensures that the value of
percpu_ref is stable after percpu_ref_switch_to_atomic_sync() returns.  So
just do it.

Link: https://lkml.kernel.org/r/20220407103335.36885-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/percpu-refcount.c~percpu_ref-call-wake_up_all-after-percpu_ref_put-completes
+++ a/lib/percpu-refcount.c
@@ -154,13 +154,14 @@ static void percpu_ref_call_confirm_rcu(
 
 	data->confirm_switch(ref);
 	data->confirm_switch = NULL;
-	wake_up_all(&percpu_ref_switch_waitq);
 
 	if (!data->allow_reinit)
 		__percpu_ref_exit(ref);
 
 	/* drop ref from percpu_ref_switch_to_atomic() */
 	percpu_ref_put(ref);
+
+	wake_up_all(&percpu_ref_switch_waitq);
 }
 
 static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

percpu_ref-call-wake_up_all-after-percpu_ref_put-completes.patch

