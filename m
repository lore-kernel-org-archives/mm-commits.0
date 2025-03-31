Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7245ADDBC
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 21:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457091; cv=none; b=iyD92niZZKlF9eomfkml/VwbVpo7gZq+G7OsHoxHzx++ErZu8iDTByPl4Penc7/3cfS2DXcuekyTfdsyBcvTDrD8Ky+KJ280KDhlSuhTFzOeZyBk/5vSws3DoyMHo4KgEhk9r+Cr6EZ6qlDIFwLY+H/sBBgCS6h7hsdsVrSD8fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457091; c=relaxed/simple;
	bh=FC9d/zvTQIoqYVKS+KsUTXnXu4wX/L2ibmFgsOsl/N8=;
	h=Date:To:From:Subject:Message-Id; b=CXQ0TAg35u1UJn3ToELbOrbMsaQ2076gy3YPt5yfQpL82jE9m7afuP6nWTM/ZlH0gsWbsJCyQ0mZrYS1YC5lcqbI+iBKzI5mrbXoXK5PVyA5Xsi88gzSxLeGYqTYsruBTpHAG7cN15CBhF3BM/C6AkWPh3/53CPvboGhHhebFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dbmCVS9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dbmCVS9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8F5C4CEE3;
	Mon, 31 Mar 2025 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743457090;
	bh=FC9d/zvTQIoqYVKS+KsUTXnXu4wX/L2ibmFgsOsl/N8=;
	h=Date:To:From:Subject:From;
	b=dbmCVS9CWgyvhCwk+Nzh/Bz0fsg3Hj4ggH+6NUu5Z/WxSFqjoLSMWxZ+jw62J5Vyl
	 1PpCM9ggXTCuUSpxHMCpPYGGhvd4ZD+dnDYvgDFLxarFQDUUWThntvsRlcAOV3LhiH
	 Jdh6VJv+EWO0a4o7jwb4BJGZDQN+aw/N7QzEUgPc=
Date: Mon, 31 Mar 2025 14:38:10 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,x86@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch added to mm-new branch
Message-Id: <20250331213810.CF8F5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix the outdated code comments above get_user_pages_unlocked()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: fix the outdated code comments above get_user_pages_unlocked()
Date: Mon, 31 Mar 2025 16:13:23 +0800

Since commit f0818f472d8d ("mm: gup: add get_user_pages_locked and
get_user_pages_unlocked"), get_user_pages() doesn't need to have mmap_lock
held anymore.  It calls __get_user_pages_locked() which can acquire and
drop the mmap_lock internaly.

Hence remove the incorrect code comments now.

Link: https://lkml.kernel.org/r/20250331081327.256412-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: <x86@kernel.org>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/gup.c~mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked
+++ a/mm/gup.c
@@ -2702,19 +2702,9 @@ long get_user_pages(unsigned long start,
 EXPORT_SYMBOL(get_user_pages);
 
 /*
- * get_user_pages_unlocked() is suitable to replace the form:
- *
- *      mmap_read_lock(mm);
- *      get_user_pages(mm, ..., pages, NULL);
- *      mmap_read_unlock(mm);
- *
- *  with:
- *
- *      get_user_pages_unlocked(mm, ..., pages);
- *
- * It is functionally equivalent to get_user_pages_fast so
- * get_user_pages_fast should be used instead if specific gup_flags
- * (e.g. FOLL_FORCE) are not required.
+ * get_user_pages_unlocked() is functionally equivalent to
+ * get_user_pages_fast so get_user_pages_fast should be used instead
+ * if specific gup_flags (e.g. FOLL_FORCE) are not required.
  */
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 			     struct page **pages, unsigned int gup_flags)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

