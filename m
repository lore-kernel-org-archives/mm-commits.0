From: akpm@linux-foundation.org
Subject: +
 drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch
 added to -mm tree
Date: Wed, 02 Dec 2015 14:46:25 -0800
Message-ID: <565f74c1.MWt2JeG7ljXwJXnG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbbLBWq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjennings@variantweb.net, abanman@sgi.com, daniel@numascale.com, greg@kroah.com, rja@sgi.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory.c: rename remove_memory_block() to remove_memory_section()
has been added to the -mm tree.  Its filename is
     drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch

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
Subject: drivers/base/memory.c: rename remove_memory_block() to remove_memory_section()

The function removes a section, not a block.  Rename to reflect actual
functionality.

Signed-off-by: Seth Jennings <sjennings@variantweb.net>
Cc: Andrew Banman <abanman@sgi.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Russ Anderson <rja@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~drivers-memory-rename-remove_memory_block-to-remove_memory_section drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-memory-rename-remove_memory_block-to-remove_memory_section
+++ a/drivers/base/memory.c
@@ -692,7 +692,7 @@ unregister_memory(struct memory_block *m
 	device_unregister(&memory->dev);
 }
 
-static int remove_memory_block(unsigned long node_id,
+static int remove_memory_section(unsigned long node_id,
 			       struct mem_section *section, int phys_device)
 {
 	struct memory_block *mem;
@@ -716,7 +716,7 @@ int unregister_memory_section(struct mem
 	if (!present_section(section))
 		return -EINVAL;
 
-	return remove_memory_block(0, section, 0);
+	return remove_memory_section(0, section, 0);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
_

Patches currently in -mm which might be from sjennings@variantweb.net are

drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections.patch
drivers-memory-clean-up-section-counting.patch
drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch

