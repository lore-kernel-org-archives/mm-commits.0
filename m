From: akpm@linux-foundation.org
Subject: + mm-convert-to-define_debugfs_attribute.patch added to -mm tree
Date: Tue, 30 May 2017 14:29:54 -0700
Message-ID: <592de452.E9QTbK+HvwzuFayg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdE3V3z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 17:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y.pronenko@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: convert to DEFINE_DEBUGFS_ATTRIBUTE
has been added to the -mm tree.  Its filename is
     mm-convert-to-define_debugfs_attribute.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-to-define_debugfs_attribute.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-to-define_debugfs_attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3300,14 +3300,14 @@ static int fault_around_bytes_set(void *
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

Patches currently in -mm which might be from y.pronenko@gmail.com are

mm-convert-to-define_debugfs_attribute.patch

