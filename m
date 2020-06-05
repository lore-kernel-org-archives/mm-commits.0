From: akpm@linux-foundation.org
Subject: [merged] arch-sh-vmlinuxscr-align-rodata.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:21:22 -0700
Message-ID: <20200605202122.W5SLi3r9X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEUVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: arch/sh: vmlinux.scr: align .rodata
has been removed from the -mm tree.  Its filename was
     arch-sh-vmlinuxscr-align-rodata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Romain Naour <romain.naour@gmail.com>
Subject: arch/sh: vmlinux.scr: align .rodata

Since the patch [1], building the kernel using a toolchain built with
Binutils 2.33.1 prevent booting a sh4 system under Qemu.  Apply the patch
provided by Alan Modra [2] that fix alignment of rodata.

[1] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=ebd2263ba9a9124d93bbc0ece63d7e0fae89b40e
[2] https://www.sourceware.org/ml/binutils/2019-12/msg00112.html

Link: https://marc.info/?l=linux-sh&m=158429470120959
Signed-off-by: Romain Naour <romain.naour@gmail.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boot/compressed/vmlinux.scr |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/boot/compressed/vmlinux.scr~arch-sh-vmlinuxscr-align-rodata
+++ a/arch/sh/boot/compressed/vmlinux.scr
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .rodata..compressed : {
+  .rodata..compressed : ALIGN(8) {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
_

Patches currently in -mm which might be from romain.naour@gmail.com are

include-asm-generic-vmlinuxldsh-align-ro_after_init.patch
