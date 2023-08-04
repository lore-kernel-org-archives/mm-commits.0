Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CA4C001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjHDRN1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjHDRN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49408198B
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7B73620AF
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293BDC433C7;
        Fri,  4 Aug 2023 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691169204;
        bh=DRZvSOrhCViOamX+qxwzH/qiFs0YjOFNQubZXqGUjEw=;
        h=Date:To:From:Subject:From;
        b=BUuqgtVLyDrSHRtg7j7GxCcpL9kBphuIkedWZTVvSkHYJiPoGaKZiRGPBf9BsHVxU
         NCSySICHRXHQYw351vURTaU5tX6Hy9LSIZwnhutAL9RrgZZWjvKiezHdMrvfCSHX9y
         MDPRL9dwsqWeHk1OK28xJ7SrWHpaOvDrAsZyxua0=
Date:   Fri, 04 Aug 2023 10:13:21 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com,
        samitolvanen@google.com, quic_pbaronia@quicinc.com,
        qiang1.zhang@intel.com, peterz@infradead.org, npiggin@gmail.com,
        michael.christie@oracle.com, keescook@chromium.org,
        jstultz@google.com, brauner@kernel.org, arve@android.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-unexport-__kthread_should_park.patch added to mm-nonmm-unstable branch
Message-Id: <20230804171324.293BDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: unexport __kthread_should_park()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-unexport-__kthread_should_park.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-unexport-__kthread_should_park.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kthread: unexport __kthread_should_park()
Date: Fri, 4 Aug 2023 08:41:51 +0200

There are no in-kernel users of __kthread_should_park() so mark it as
static and do not export it.

Link: https://lkml.kernel.org/r/2023080450-handcuff-stump-1d6e@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: John Stultz <jstultz@google.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: "Arve Hjønnevåg" <arve@android.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Christian Brauner (Microsoft)" <brauner@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Zqiang <qiang1.zhang@intel.com>
Cc: Prathu Baronia <quic_pbaronia@quicinc.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    1 -
 kernel/kthread.c        |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/kthread.h~kthread-unexport-__kthread_should_park
+++ a/include/linux/kthread.h
@@ -88,7 +88,6 @@ void kthread_bind_mask(struct task_struc
 int kthread_stop(struct task_struct *k);
 bool kthread_should_stop(void);
 bool kthread_should_park(void);
-bool __kthread_should_park(struct task_struct *k);
 bool kthread_should_stop_or_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_func(struct task_struct *k);
--- a/kernel/kthread.c~kthread-unexport-__kthread_should_park
+++ a/kernel/kthread.c
@@ -159,11 +159,10 @@ bool kthread_should_stop(void)
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
-bool __kthread_should_park(struct task_struct *k)
+static bool __kthread_should_park(struct task_struct *k)
 {
 	return test_bit(KTHREAD_SHOULD_PARK, &to_kthread(k)->flags);
 }
-EXPORT_SYMBOL_GPL(__kthread_should_park);
 
 /**
  * kthread_should_park - should this kthread park now?
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

kthread-unexport-__kthread_should_park.patch

