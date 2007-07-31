From: akpm@linux-foundation.org
Subject: - include-serial_regh-with-userspace-headers.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:28 -0700
Message-ID: <200707312357.l6VNvSHt029400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764168AbXHAASX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herton@mandriva.com.br, dwmw2@infradead.org, gustavodn@mandriva.com.br, rmk@arm.linux.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Include serial_reg.h with userspace headers
has been removed from the -mm tree.  Its filename was
     include-serial_regh-with-userspace-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Include serial_reg.h with userspace headers
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

As reported by Gustavo de Nardin <gustavodn@mandriva.com.br>, while trying to
compile xosview (http://xosview.sourceforge.net/) with upstream kernel
headers being used you get the following errors:
serialmeter.cc:48:30: error: linux/serial_reg.h: No such file or directory
serialmeter.cc: In member function 'virtual void
SerialMeter::checkResources()':
serialmeter.cc:71: error: 'UART_LSR' was not declared in this scope
serialmeter.cc:71: error: 'UART_MSR' was not declared in this scope
...

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Gustavo de Nardin <gustavodn@mandriva.com.br>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~include-serial_regh-with-userspace-headers include/linux/Kbuild
--- a/include/linux/Kbuild~include-serial_regh-with-userspace-headers
+++ a/include/linux/Kbuild
@@ -137,6 +137,7 @@ header-y += radeonfb.h
 header-y += raw.h
 header-y += resource.h
 header-y += rose.h
+header-y += serial_reg.h
 header-y += smbno.h
 header-y += snmp.h
 header-y += sockios.h
_

Patches currently in -mm which might be from herton@mandriva.com.br are

origin.patch
