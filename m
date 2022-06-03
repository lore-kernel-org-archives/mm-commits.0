Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651B0C43334
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 16:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiFCQtM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 12:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344080AbiFCQtM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 12:49:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5FF4D62E
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 09:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15454B82373
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 16:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72A2C385B8;
        Fri,  3 Jun 2022 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654274947;
        bh=46n6+kJwM7SefRWPKymQFF75QOW0XEjr5AlbNIXuYE4=;
        h=Date:To:From:Subject:From;
        b=rRmKMYIo8wmJiSveFolcp/Oe+3I1DBGPZ+PBiP4CKDRF7w6+F9iH6qQCjZv8jg9YK
         9PuzUd+vDvF3bDznjrSfJGWtGSmUJ/QyDu012RM1K/A1mBLy+9UG6iN7IaxgAVVFoB
         Xb73OtjEbSzQe219krh1QkLjwNJqrzoprr1ubYrY=
Date:   Fri, 03 Jun 2022 09:49:07 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, lkp@intel.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch added to mm-unstable branch
Message-Id: <20220603164907.B72A2C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch

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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
Date: Fri, 3 Jun 2022 02:10:43 +0000

build fix

__get_huge_page_for_hwpoison() is not needed when CONFIG_HUGETLB_PAGE is
n, so extending "#ifdef CONFIG_HUGETLB_PAG" to cover
__get_huge_page_for_hwpoison() would be a simple resolution.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
+++ a/mm/memory-failure.c
@@ -1496,6 +1496,7 @@ static int try_to_split_thp_page(struct
 	return 0;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Called from hugetlb code with hugetlb_lock held.
  *
@@ -1544,7 +1545,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page.patch
mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch
mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

