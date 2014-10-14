From: akpm@linux-foundation.org
Subject: [merged] kernel-kallsymsc-use-__seq_open_private.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:20:01 -0700
Message-ID: <543d6951.2QZBeN0QFdWdpWU/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJNST7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, gidisrael@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kallsyms.c: use __seq_open_private()
has been removed from the -mm tree.  Its filename was
     kernel-kallsymsc-use-__seq_open_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Jones <rob.jones@codethink.co.uk>
Subject: kernel/kallsyms.c: use __seq_open_private()

Reduce boilerplate code by using __seq_open_private() instead of seq_open()
in kallsyms_open().

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Cc: Gideon Israel Dsouza <gidisrael@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN kernel/kallsyms.c~kernel-kallsymsc-use-__seq_open_private kernel/kallsyms.c
--- a/kernel/kallsyms.c~kernel-kallsymsc-use-__seq_open_private
+++ a/kernel/kallsyms.c
@@ -565,19 +565,12 @@ static int kallsyms_open(struct inode *i
 	 * using get_symbol_offset for every symbol.
 	 */
 	struct kallsym_iter *iter;
-	int ret;
