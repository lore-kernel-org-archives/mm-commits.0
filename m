From: akpm@linux-foundation.org
Subject: + include-serial_regh-with-userspace-headers.patch added to -mm tree
Date: Wed, 18 Jul 2007 18:08:34 -0700
Message-ID: <200707190108.l6J18YrN006434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763557AbXGSBKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 21:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herton@mandriva.com.br, dwmw2@infradead.org, gustavodn@mandriva.com.br, rmk@arm.linux.org.uk, stable@kernel.org


The patch titled
     Include serial_reg.h with userspace headers
has been added to the -mm tree.  Its filename is
     include-serial_regh-with-userspace-headers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

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

include-serial_regh-with-userspace-headers.patch
