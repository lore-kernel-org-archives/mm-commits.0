Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5A2C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 10 Feb 2022 01:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiBJB51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Feb 2022 20:57:27 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbiBJB4N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2022 20:56:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8AC2BB19
        for <mm-commits@vger.kernel.org>; Wed,  9 Feb 2022 17:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B7A8616BE
        for <mm-commits@vger.kernel.org>; Thu, 10 Feb 2022 00:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82EDC340E7;
        Thu, 10 Feb 2022 00:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644453245;
        bh=oGn43zGO/cPllwktffxpEGhC2+pwKsIjei+SVaf3CNw=;
        h=Date:To:From:Subject:From;
        b=g2jOjxSOi+JPsLlf/pluTNyPP/3q5bib9rz+TJ9Uwb7u4FDeTrRx0ayKImGyBOroV
         fTbDmr34Ur324wvO4r3mcHnZm2Mu9jQLG0wvWOE8ImW7XVmb0IUMEf4MCr4Yeb37aD
         yaTeWbYMQYPOMJr5Ax8lD9/4BiSFsct4Wq0AH8X0=
Date:   Wed, 09 Feb 2022 16:34:05 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        syzbot+aa7b3d4b35f9dc46a366@syzkaller.appspotmail.com,
        sumit.semwal@linaro.org, sashal@kernel.org, pcc@google.com,
        mhocko@suse.com, legion@kernel.org,
        kirill.shutemov@linux.intel.com, keescook@chromium.org,
        hannes@cmpxchg.org, gorcunov@gmail.com, ebiederm@xmission.com,
        david@redhat.com, dave@stgolabs.net, dave.hansen@intel.com,
        chris.hyser@oracle.com, ccross@google.com, caoxiaofeng@yulong.com,
        brauner@kernel.org, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed.patch added to -mm tree
Message-Id: <20220210003405.C82EDC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix use-after-free when anon vma name is used after vma is freed
has been added to the -mm tree.  Its filename is
     mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix use-after-free when anon vma name is used after vma is freed

When adjacent vmas are being merged it can result in the vma that was
originally passed to madvise_update_vma being destroyed.  In the current
implementation, the name parameter passed to madvise_update_vma points
directly to vma->anon_name->name and it is used after the call to
vma_merge.  In the cases when vma_merge merges the original vma and
destroys it, this will result in use-after-free bug as shown below:

madvise_vma_behavior << passes vma->anon_name->name as name param
  madvise_update_vma(name)
    vma_merge
      __vma_adjust
        vm_area_free <-- frees the vma
    replace_vma_anon_name(name) <-- UAF

Fix this by passing madvise_update_vma a copy of the name.

Link: https://lkml.kernel.org/r/20220210001801.15413-1-surenb@google.com
Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: <syzbot+aa7b3d4b35f9dc46a366@syzkaller.appspotmail.com>
Cc: Colin Cross <ccross@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Chris Hyser <chris.hyser@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Xiaofeng Cao <caoxiaofeng@yulong.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 kernel/sys.c       |    1 -
 mm/madvise.c       |   14 +++++++++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed
+++ a/include/linux/mm.h
@@ -3370,6 +3370,8 @@ static inline int seal_check_future_writ
 	return 0;
 }
 
+#define ANON_VMA_NAME_MAX_LEN	80
+
 #ifdef CONFIG_ANON_VMA_NAME
 int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 			  unsigned long len_in, const char *name);
--- a/kernel/sys.c~mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed
+++ a/kernel/sys.c
@@ -2263,7 +2263,6 @@ int __weak arch_prctl_spec_ctrl_set(stru
 
 #ifdef CONFIG_ANON_VMA_NAME
 
-#define ANON_VMA_NAME_MAX_LEN		80
 #define ANON_VMA_NAME_INVALID_CHARS	"\\`$[]"
 
 static inline bool is_valid_name_char(char ch)
--- a/mm/madvise.c~mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed
+++ a/mm/madvise.c
@@ -976,6 +976,8 @@ static int madvise_vma_behavior(struct v
 {
 	int error;
 	unsigned long new_flags = vma->vm_flags;
+	char name_buf[ANON_VMA_NAME_MAX_LEN];
+	const char *anon_name;
 
 	switch (behavior) {
 	case MADV_REMOVE:
@@ -1040,8 +1042,18 @@ static int madvise_vma_behavior(struct v
 		break;
 	}
 
+	anon_name = vma_anon_name(vma);
+	if (anon_name) {
+		/*
+		 * Make a copy of the name because vma might be destroyed when
+		 * merged with another one and the name parameter might be used
+		 * after that.
+		 */
+		strcpy(name_buf, anon_name);
+		anon_name = name_buf;
+	}
 	error = madvise_update_vma(vma, prev, start, end, new_flags,
-				   vma_anon_name(vma));
+				   anon_name);
 
 out:
 	/*
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-uaf-when-anon-vma-name-is-used-after-vma-is-freed.patch

