From: akpm@linux-foundation.org
Subject: [merged]
 drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:01 -0800
Message-ID: <569973d9.RTKsVGY+knMNRM0B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjennings@variantweb.net, abanman@sgi.com, daniel@numascale.com, greg@kroah.com, rja@sgi.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory.c: rename remove_memory_block() to remove_memory_section()
has been removed from the -mm tree.  Its filename was
     drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


