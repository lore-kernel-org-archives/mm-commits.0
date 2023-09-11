Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FE9CA0EC6
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243680AbjIKWYd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244026AbjIKSrM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:47:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5531AD
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:47:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68394C433C7;
        Mon, 11 Sep 2023 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694458027;
        bh=83KGh+brEQMXl+MO1UmOVvuQ8DrtMmMQsoCxIpAtIL8=;
        h=Date:To:From:Subject:From;
        b=aZLzTMY7V9idM+lcPf/D2ZtiJ/nRiJvd4AldatDS1yKeFiKj2+aWUTJt53/83r1ga
         A9UU9GIes5/iezKiCA5QUcZJNTEKxLE/qAxVhtVyB6aY+iFkc2nmCBy1uf++lrCnOf
         KZGk5Pops9wydBnRIH4r9SqDQTlxIFmTYsBcxrRM=
Date:   Mon, 11 Sep 2023 11:47:06 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, vbabka@suse.cz,
        thomas.lendacky@amd.com, rppt@linux.ibm.com, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, dyoung@redhat.com,
        dave.hansen@intel.com, bp@alien8.de, bhe@redhat.com,
        ardb@kernel.org, adrian.hunter@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-kcore-do-not-try-to-access-unaccepted-memory.patch added to mm-unstable branch
Message-Id: <20230911184707.68394C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/kcore: do not try to access unaccepted memory
has been added to the -mm mm-unstable branch.  Its filename is
     proc-kcore-do-not-try-to-access-unaccepted-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-kcore-do-not-try-to-access-unaccepted-memory.patch

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
From: Adrian Hunter <adrian.hunter@intel.com>
Subject: proc/kcore: do not try to access unaccepted memory
Date: Mon, 11 Sep 2023 14:21:14 +0300

Support for unaccepted memory was added recently, refer commit
dcdfdd40fa82 ("mm: Add support for unaccepted memory"), whereby a virtual
machine may need to accept memory before it can be used.

Do not try to access unaccepted memory because it can cause the guest to
fail.

For /proc/kcore, which is read-only and does not support mmap, this means a
read of unaccepted memory will return zeros.

Link: https://lkml.kernel.org/r/20230911112114.91323-3-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/kcore.c~proc-kcore-do-not-try-to-access-unaccepted-memory
+++ a/fs/proc/kcore.c
@@ -546,7 +546,8 @@ static ssize_t read_kcore_iter(struct ki
 			 * and explicitly excluded physical ranges.
 			 */
 			if (!page || PageOffline(page) ||
-			    is_page_hwpoison(page) || !pfn_is_ram(pfn)) {
+			    is_page_hwpoison(page) || !pfn_is_ram(pfn) ||
+			    pfn_is_unaccepted_memory(pfn)) {
 				if (iov_iter_zero(tsz, iter) != tsz) {
 					ret = -EFAULT;
 					goto out;
_

Patches currently in -mm which might be from adrian.hunter@intel.com are

efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory.patch
proc-kcore-do-not-try-to-access-unaccepted-memory.patch

