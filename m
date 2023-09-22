Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A487E7D0BE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjIVBep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjIVBem (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:34:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFB2CF
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:34:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A576C433C7;
        Fri, 22 Sep 2023 01:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346475;
        bh=futD76jBIYZRo8vID6SgRepgU3sy/uFQsMASqc58bOs=;
        h=Date:To:From:Subject:From;
        b=Vala6UzETArKel3YKLEWT07pSs3lzsAbHtaJ0wEP+tx96qPoQvZMbLDwp0vSboioZ
         JFQyPG19MzXXwGwN4Q07nw8zYGKGRsFic9DYJw3mTAi2fQXjioItvsjlGnMnryjF9D
         YqUNfutqjS/j5r+e/k0xXcrDUqT5ioXDFe0swOLY=
Date:   Thu, 21 Sep 2023 18:34:35 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
        mhocko@suse.com, kpsingh@kernel.org, keescook@chromium.org,
        joey.gouly@arm.com, izbyshev@ispras.ru, gthelen@google.com,
        david@redhat.com, catalin.marinas@arm.com, broonie@kernel.org,
        ayush.jain3@amd.com, anshuman.khandual@arm.com,
        revest@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch added to mm-unstable branch
Message-Id: <20230922013435.8A576C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a NO_INHERIT flag to the PR_SET_MDWE prctl
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch

This patch will later appear in the mm-unstable branch at
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
From: Florent Revest <revest@chromium.org>
Subject: mm: add a NO_INHERIT flag to the PR_SET_MDWE prctl
Date: Mon, 28 Aug 2023 17:08:57 +0200

This extends the current PR_SET_MDWE prctl arg with a bit to indicate that
the process doesn't want MDWE protection to propagate to children.

To implement this no-inherit mode, the tag in current->mm->flags must be
absent from MMF_INIT_MASK.  This means that the encoding for "MDWE but
without inherit" is different in the prctl than in the mm flags.  This
leads to a bit of bit-mangling in the prctl implementation.

Link: https://lkml.kernel.org/r/20230828150858.393570-6-revest@chromium.org
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/coredump.h   |   10 +++++++++
 include/uapi/linux/prctl.h       |    1 
 kernel/fork.c                    |    2 -
 kernel/sys.c                     |   32 +++++++++++++++++++++++------
 tools/include/uapi/linux/prctl.h |    1 
 5 files changed, 39 insertions(+), 7 deletions(-)

--- a/include/linux/sched/coredump.h~mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl
+++ a/include/linux/sched/coredump.h
@@ -91,4 +91,14 @@ static inline int get_dumpable(struct mm
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK)
 
 #define MMF_VM_MERGE_ANY	29
+#define MMF_HAS_MDWE_NO_INHERIT	30
+
+static inline unsigned long mmf_init_flags(unsigned long flags)
+{
+	if (flags & (1UL << MMF_HAS_MDWE_NO_INHERIT))
+		flags &= ~((1UL << MMF_HAS_MDWE) |
+			   (1UL << MMF_HAS_MDWE_NO_INHERIT));
+	return flags & MMF_INIT_MASK;
+}
+
 #endif /* _LINUX_SCHED_COREDUMP_H */
--- a/include/uapi/linux/prctl.h~mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl
+++ a/include/uapi/linux/prctl.h
@@ -284,6 +284,7 @@ struct prctl_mm_map {
 /* Memory deny write / execute */
 #define PR_SET_MDWE			65
 # define PR_MDWE_REFUSE_EXEC_GAIN	(1UL << 0)
+# define PR_MDWE_NO_INHERIT		(1UL << 1)
 
 #define PR_GET_MDWE			66
 
--- a/kernel/fork.c~mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl
+++ a/kernel/fork.c
@@ -1288,7 +1288,7 @@ static struct mm_struct *mm_init(struct
 	hugetlb_count_init(mm);
 
 	if (current->mm) {
-		mm->flags = current->mm->flags & MMF_INIT_MASK;
+		mm->flags = mmf_init_flags(current->mm->flags);
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
 	} else {
 		mm->flags = default_dump_filter;
--- a/kernel/sys.c~mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl
+++ a/kernel/sys.c
@@ -2368,19 +2368,41 @@ static int prctl_set_vma(unsigned long o
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 
+static inline unsigned long get_current_mdwe(void)
+{
+	unsigned long ret = 0;
+
+	if (test_bit(MMF_HAS_MDWE, &current->mm->flags))
+		ret |= PR_MDWE_REFUSE_EXEC_GAIN;
+	if (test_bit(MMF_HAS_MDWE_NO_INHERIT, &current->mm->flags))
+		ret |= PR_MDWE_NO_INHERIT;
+
+	return ret;
+}
+
 static inline int prctl_set_mdwe(unsigned long bits, unsigned long arg3,
 				 unsigned long arg4, unsigned long arg5)
 {
+	unsigned long current_bits;
+
 	if (arg3 || arg4 || arg5)
 		return -EINVAL;
 
-	if (bits & ~(PR_MDWE_REFUSE_EXEC_GAIN))
+	if (bits & ~(PR_MDWE_REFUSE_EXEC_GAIN | PR_MDWE_NO_INHERIT))
+		return -EINVAL;
+
+	/* NO_INHERIT only makes sense with REFUSE_EXEC_GAIN */
+	if (bits & PR_MDWE_NO_INHERIT && !(bits & PR_MDWE_REFUSE_EXEC_GAIN))
 		return -EINVAL;
 
+	current_bits = get_current_mdwe();
+	if (current_bits && current_bits != bits)
+		return -EPERM; /* Cannot unset the flags */
+
+	if (bits & PR_MDWE_NO_INHERIT)
+		set_bit(MMF_HAS_MDWE_NO_INHERIT, &current->mm->flags);
 	if (bits & PR_MDWE_REFUSE_EXEC_GAIN)
 		set_bit(MMF_HAS_MDWE, &current->mm->flags);
-	else if (test_bit(MMF_HAS_MDWE, &current->mm->flags))
-		return -EPERM; /* Cannot unset the flag */
 
 	return 0;
 }
@@ -2390,9 +2412,7 @@ static inline int prctl_get_mdwe(unsigne
 {
 	if (arg2 || arg3 || arg4 || arg5)
 		return -EINVAL;
-
-	return test_bit(MMF_HAS_MDWE, &current->mm->flags) ?
-		PR_MDWE_REFUSE_EXEC_GAIN : 0;
+	return get_current_mdwe();
 }
 
 static int prctl_get_auxv(void __user *addr, unsigned long len)
--- a/tools/include/uapi/linux/prctl.h~mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl
+++ a/tools/include/uapi/linux/prctl.h
@@ -284,6 +284,7 @@ struct prctl_mm_map {
 /* Memory deny write / execute */
 #define PR_SET_MDWE			65
 # define PR_MDWE_REFUSE_EXEC_GAIN	(1UL << 0)
+# define PR_MDWE_NO_INHERIT		(1UL << 1)
 
 #define PR_GET_MDWE			66
 
_

Patches currently in -mm which might be from revest@chromium.org are

kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test.patch
kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch
kselftest-vm-check-errnos-in-mdwe_test.patch
mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch
mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch
kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch

