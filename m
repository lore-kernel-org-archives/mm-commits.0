From: akpm@linux-foundation.org
Subject: +
 drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections.patch added to -mm tree
Date: Wed, 02 Dec 2015 14:46:01 -0800
Message-ID: <565f74a9.U6rxwFW10ihtsdCs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbbLBWqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:46:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjennings@variantweb.net, abanman@sgi.com, daniel@numascale.com, greg@kroah.com, rja@sgi.com, stable@vger.kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory.c: prohibit offlining of memory blocks with missing sections
has been added to the -mm tree.  Its filename is
     drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Seth Jennings <sjennings@variantweb.net>
Subject: drivers/base/memory.c: prohibit offlining of memory blocks with missing sections

bdee237c ("x86: mm: Use 2GB memory block size on large-memory x86-64
systems") and 982792c7 ("x86, mm: probe memory block size for generic x86
64bit") introduced large block sizes for x86.  This made it possible to
have multiple sections per memory block where previously, there was a only
every one section per block.

Since blocks consist of contiguous ranges of section, there can be holes
in the blocks where sections are not present.  If one attempts to offline
such a block, a crash occurs since the code is not designed to deal with
this.

This patch is a quick fix to gaurd against the crash by not allowing
blocks with non-present sections to be offlined.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=107781

Signed-off-by: Seth Jennings <sjennings@variantweb.net>
Reported-by: Andrew Banman <abanman@sgi.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/base/memory.c~drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections
+++ a/drivers/base/memory.c
@@ -303,6 +303,10 @@ static int memory_subsys_offline(struct
 	if (mem->state == MEM_OFFLINE)
 		return 0;
 
+	/* Can't offline block with non-present sections */
+	if (mem->section_count != sections_per_block)
+		return -EINVAL;
+
 	return memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
 }
 
_

Patches currently in -mm which might be from sjennings@variantweb.net are

drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections.patch
drivers-memory-clean-up-section-counting.patch
drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch

