From: akpm@linux-foundation.org
Subject: [merged] printk-fix-incorrect-length-from-print_time-when-seconds-99999.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:27:04 -0800
Message-ID: <20130107192705.3BB8F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:55610 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3AGT1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:27:08 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so1261077wgb.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:27:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@purestorage.com, gregkh@linuxfoundation.org, joe@perches.com, s.munaut@whatever-company.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix incorrect length from print_time() when seconds > 99999
has been removed from the -mm tree.  Its filename was
     printk-fix-incorrect-length-from-print_time-when-seconds-99999.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roland Dreier <roland@purestorage.com>
Subject: printk: fix incorrect length from print_time() when seconds > 99999

print_prefix() passes a NULL buf to print_time() to get the length of the
time prefix; when printk times are enabled, the current code just returns
the constant 15, which matches the format "[%5lu.%06lu] " used to print
the time value.  However, this is obviously incorrect when the whole
seconds part of the time gets beyond 5 digits (100000 seconds is a bit
more than a day of uptime).

The simple fix is to use snprintf(NULL, 0, ...) to calculate the actual
length of the time prefix.  This could be micro-optimized but it seems
better to have simpler, more readable code here.

The bug leads to the syslog system call miscomputing which messages fit
into the userspace buffer.  If there are enough messages to fill
log_buf_len and some have a timestamp >= 100000, dmesg may fail with:

    # dmesg
    klogctl: Bad address

When this happens, strace shows that the failure is indeed EFAULT due to
the kernel mistakenly accessing past the end of dmesg's buffer, since
dmesg asks the kernel how big a buffer it needs, allocates a bit more, and
then gets an error when it asks the kernel to fill it:

    syslog(0xa, 0, 0)                       = 1048576
    mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa4d25d2000
    syslog(0x3, 0x7fa4d25d2010, 0x100008)   = -1 EFAULT (Bad address)

As far as I can see, the bug has been there as long as print_time(), which
comes from 084681d14e42 ("printk: flush continuation lines immediately to
console") in 3.5-rc5.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Sylvain Munaut <s.munaut@whatever-company.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-fix-incorrect-length-from-print_time-when-seconds-99999 kernel/printk.c
--- a/kernel/printk.c~printk-fix-incorrect-length-from-print_time-when-seconds-99999
+++ a/kernel/printk.c
@@ -870,10 +870,11 @@ static size_t print_time(u64 ts, char *b
 	if (!printk_time)
 		return 0;
 
+	rem_nsec = do_div(ts, 1000000000);
+
 	if (!buf)
-		return 15;
+		return snprintf(NULL, 0, "[%5lu.000000] ", (unsigned long)ts);
 
-	rem_nsec = do_div(ts, 1000000000);
 	return sprintf(buf, "[%5lu.%06lu] ",
 		       (unsigned long)ts, rem_nsec / 1000);
 }
_

Patches currently in -mm which might be from roland@purestorage.com are

origin.patch

