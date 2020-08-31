Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDA6C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 220D92083E
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598903179;
	bh=tzbXsW6HnGZu5311z+fM87bjaTAXF5VcrC+AeN12zgA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Cpno1KhbKNL7hEzx3T9sbmEeeDdwaAXVUsLwKAUhj34zVkAN3sojd5CKMoSQh6yTv
	 2HvtrrjNS4anuWPqug9I7uTlmqsl+7SBNMZxMSivjvQt3oAfHEC/7MeNZSRd8XJlWl
	 wo/wUSPzm6i3fTH4NKrdxCDnHCruvVmeHb4U+Zos=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgHaTqS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgHaTqS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 15:46:18 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 197D5206F0;
        Mon, 31 Aug 2020 19:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598903177;
        bh=tzbXsW6HnGZu5311z+fM87bjaTAXF5VcrC+AeN12zgA=;
        h=Date:From:To:Subject:From;
        b=MYUCdJ41a9Q6Xuht3bF8F47npgZBo45pE9Z/GXx42WOj7+aAfVaK8kj03UKhfOE0t
         3UEB0QhubSGEofONDbfrSFCxAF+aj40rOmWHUR+c4cjnuSpfiS3BLkUcmqrq2ySKXe
         gch94BU93nqb0rBxVKkobWxvA3kDg7xxQ7I7DngA=
Date:   Mon, 31 Aug 2020 12:46:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
        songliubraving@fb.com, rostedt@goodmis.org,
        naveen.n.rao@linux.ibm.com, mhiramat@kernel.org,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com,
        songmuchun@bytedance.com
Subject:  +
 kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch added to -mm tree
Message-ID: <20200831194616.vHkMt%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: fix kill kprobe which has been marked as gone
has been added to the -mm tree.  Its filename is
     kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: kprobes: fix kill kprobe which has been marked as gone

If a kprobe is marked as gone, we should not kill it again.  Otherwise, we
can disarm the kprobe more than once.  In that case, the statistics of
kprobe_ftrace_enabled can unbalance which can lead to that kprobe do not
work.

Link: https://lkml.kernel.org/r/20200822030055.32383-1-songmuchun@bytedance.com
Fixes: e8386a0cb22f ("kprobes: support probing module __exit function")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Song Liu <songliubraving@fb.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/kprobes.c~kprobes-fix-kill-kprobe-which-has-been-marked-as-gone
+++ a/kernel/kprobes.c
@@ -2140,6 +2140,9 @@ static void kill_kprobe(struct kprobe *p
 
 	lockdep_assert_held(&kprobe_mutex);
 
+	if (WARN_ON_ONCE(kprobe_gone(p)))
+		return;
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (kprobe_aggrprobe(p)) {
 		/*
@@ -2419,7 +2422,10 @@ static int kprobes_module_callback(struc
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry(p, head, hlist)
+		hlist_for_each_entry(p, head, hlist) {
+			if (kprobe_gone(p))
+				continue;
+
 			if (within_module_init((unsigned long)p->addr, mod) ||
 			    (checkcore &&
 			     within_module_core((unsigned long)p->addr, mod))) {
@@ -2436,6 +2442,7 @@ static int kprobes_module_callback(struc
 				 */
 				kill_kprobe(p);
 			}
+		}
 	}
 	if (val == MODULE_STATE_GOING)
 		remove_module_kprobe_blacklist(mod);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-a-race-between-hugetlb-sysctl-handlers.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch
kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch

