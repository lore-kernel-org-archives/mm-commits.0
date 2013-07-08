From: akpm@linux-foundation.org
Subject: [merged]
 c6x-normalize-global-variables-exported-by-vmlinuxlds.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:26:38 -0700
Message-ID: <51db126e.RLnWEKWZSJ1P18gb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3GHT0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, msalter@redhat.com, jiang.liu@huawei.com, a-jacquiot@ti.com, liuj97@gmail.com

Subject: [merged] c6x-normalize-global-variables-exported-by-vmlinuxlds.patch removed from -mm tree
To: liuj97@gmail.com,a-jacquiot@ti.com,jiang.liu@huawei.com,msalter@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:38 -0700


The patch titled
     Subject: c6x: normalize global variables exported by vmlinux.lds
has been removed from the -mm tree.  Its filename was
     c6x-normalize-global-variables-exported-by-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: c6x: normalize global variables exported by vmlinux.lds

Normalize global variables exported by vmlinux.lds to conform usage
guidelines from include/asm-generic/sections.h.

Use _text to mark the start of the kernel image including the head text,
and _stext to mark the start of the .text section.

This patch also fixes possible bugs due to current address layout that
[__init_begin, __init_end] is a sub-range of [_stext, _etext] and pages
within range [__init_begin, __init_end] will be freed by free_initmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/kernel/vmlinux.lds.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/c6x/kernel/vmlinux.lds.S~c6x-normalize-global-variables-exported-by-vmlinuxlds arch/c6x/kernel/vmlinux.lds.S
--- a/arch/c6x/kernel/vmlinux.lds.S~c6x-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/c6x/kernel/vmlinux.lds.S
@@ -54,16 +54,15 @@ SECTIONS
 	}
 
 	. = ALIGN(PAGE_SIZE);
+	__init_begin = .;
 	.init :
 	{
-		_stext = .;
 		_sinittext = .;
 		HEAD_TEXT
 		INIT_TEXT
 		_einittext = .;
 	}
 
-	__init_begin = _stext;
 	INIT_DATA_SECTION(16)
 
 	PERCPU_SECTION(128)
@@ -74,6 +73,7 @@ SECTIONS
 	.text :
 	{
 		_text = .;
+		_stext = .;
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

