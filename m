Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6DEE7C4F6
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244026AbjJDUTD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244104AbjJDUTA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:19:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02470C9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B8FC433C9;
        Wed,  4 Oct 2023 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450737;
        bh=hZDX2TFwWz3Z6tnnLrA84r8OWgP8wgt4lMBU25HIipc=;
        h=Date:To:From:Subject:From;
        b=knlTvzvrLV6ojtBobiXiGwSjYOPT799OhajKHb317QdhpSj6UweR9NwfRqdWTg2Me
         DpXrvsWCV3rHt9ZVzefg2TWxVBqrjl8tUAospoAfOQH4BtVklniVmMvE03AZHAi2yN
         hWyfZZq7X2D9SVSWZpidemPBDF9bjIjR1mmsKoKs=
Date:   Wed, 04 Oct 2023 13:18:56 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, vbabka@suse.cz,
        thomas.lendacky@amd.com, rppt@linux.ibm.com, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, dyoung@redhat.com,
        david@redhat.com, dave.hansen@intel.com, bp@alien8.de,
        bhe@redhat.com, ardb@kernel.org, adrian.hunter@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-kcore-do-not-try-to-access-unaccepted-memory.patch removed from -mm tree
Message-Id: <20231004201857.68B8FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/kcore: do not try to access unaccepted memory
has been removed from the -mm tree.  Its filename was
     proc-kcore-do-not-try-to-access-unaccepted-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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


