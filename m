Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E737D1367
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720286980; cv=none; b=E5EGPdm7OXWGEw1BfmcsCV7YaKaGZkvjG/TxlKU6avjKQJ5nbLYjcLo+VKTy4yuCyrOENQmyTnPbi8BquRM85mJ9OfOZD9J/rUkDfwifY02g49eavfA7gNEipvBCqPc5Blf3Bvq95S2RzwoRTAjBkN2s4c1u/mfOGmBtC0FaPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720286980; c=relaxed/simple;
	bh=n6Yy1rsDCJ96eETezwxvwidP85RWPsC2TYwRpK5wT1c=;
	h=Date:To:From:Subject:Message-Id; b=Zy1WWFM+5dAOoNN5Vqdkl7vFRFwTZ6O2e5vuiD80RbY9f6Z3fzkrGfQcYzos1omkpzTNtxPwJwRVu9JNEvl43PsKPn01wVcrgFjXXbnfNL/ndfTpuQ9psfb/rniwslLEMxA6rzTm/t9Z9Q0QBL2mYMKGiNXUaDacABIQGJRnO74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RctznU18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RctznU18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761A0C2BD10;
	Sat,  6 Jul 2024 17:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720286979;
	bh=n6Yy1rsDCJ96eETezwxvwidP85RWPsC2TYwRpK5wT1c=;
	h=Date:To:From:Subject:From;
	b=RctznU187518+oAPy5nzraOhnXzdkOAXKGmYN1FwFK5fJuBWehuefgcVaI5GftMIv
	 QcTYW5CxDn+d5hnlj3bzUfExlPuCT9d4l17233co4jGm6iTTDl4doDEJGap0N2UOA2
	 qbqCozn26AexE5WlbK8qaFzygdAxVTOBgUHWnPHQ=
Date: Sat, 06 Jul 2024 10:29:38 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch added to mm-unstable branch
Message-Id: <20240706172939.761A0C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: put __free_pages_core() in __meminit section
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: put __free_pages_core() in __meminit section
Date: Sat, 6 Jul 2024 06:16:15 +0000

Function __free_pages_core() is only used in bootmem init and hot-add
memory init path.  Let's put it in __meminit section.

Link: https://lkml.kernel.org/r/20240706061615.30322-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 mm/page_alloc.c     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-page_alloc-put-__free_pages_core-in-__meminit-section
+++ a/mm/memory_hotplug.c
@@ -628,7 +628,8 @@ int restore_online_page_callback(online_
 }
 EXPORT_SYMBOL_GPL(restore_online_page_callback);
 
-void generic_online_page(struct page *page, unsigned int order)
+/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
+void __ref generic_online_page(struct page *page, unsigned int order)
 {
 	__free_pages_core(page, order, MEMINIT_HOTPLUG);
 }
--- a/mm/page_alloc.c~mm-page_alloc-put-__free_pages_core-in-__meminit-section
+++ a/mm/page_alloc.c
@@ -1219,7 +1219,7 @@ static void __free_pages_ok(struct page
 	__count_vm_events(PGFREE, 1 << order);
 }
 
-void __free_pages_core(struct page *page, unsigned int order,
+void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
 	unsigned int nr_pages = 1 << order;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

