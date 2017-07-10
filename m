From: akpm@linux-foundation.org
Subject: [patch 003/115] mm/memory.c: convert to
 DEFINE_DEBUGFS_ATTRIBUTE
Date: Mon, 10 Jul 2017 15:47:17 -0700
Message-ID: <20170710224717.ZcTT6rQ4S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754657AbdGJWrS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, y.pronenko@gmail.com

From: Yevgen Pronenko <y.pronenko@gmail.com>
Subject: mm/memory.c: convert to DEFINE_DEBUGFS_ATTRIBUTE

The preferred strategy to define debugfs attributes is to use the
DEFINE_DEBUGFS_ATTRIBUTE() macro and to use debugfs_create_file_unsafe().

Link: http://lkml.kernel.org/r/20170528145948.32127-1-y.pronenko@gmail.com
Signed-off-by: Yevgen Pronenko <y.pronenko@gmail.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-convert-to-define_debugfs_attribute mm/memory.c
--- a/mm/memory.c~mm-convert-to-define_debugfs_attribute
+++ a/mm/memory.c
@@ -3262,14 +3262,14 @@ static int fault_around_bytes_set(void *
 		fault_around_bytes = PAGE_SIZE; /* rounddown_pow_of_two(0) is undefined */
 	return 0;
 }
-DEFINE_SIMPLE_ATTRIBUTE(fault_around_bytes_fops,
+DEFINE_DEBUGFS_ATTRIBUTE(fault_around_bytes_fops,
 		fault_around_bytes_get, fault_around_bytes_set, "%llu\n");
 
 static int __init fault_around_debugfs(void)
 {
 	void *ret;
 
-	ret = debugfs_create_file("fault_around_bytes", 0644, NULL, NULL,
+	ret = debugfs_create_file_unsafe("fault_around_bytes", 0644, NULL, NULL,
 			&fault_around_bytes_fops);
 	if (!ret)
 		pr_warn("Failed to create fault_around_bytes in debugfs");
_
