From: akpm@linux-foundation.org
Subject: + printk-fix-incorrect-length-from-print_time-when-seconds-99999.patch added to -mm tree
Date: Wed, 02 Jan 2013 15:29:42 -0800
Message-ID: <20130102232943.2F08620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:49900 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3ABX3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 18:29:46 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so911281fav.0
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 15:29:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@purestorage.com, gregkh@linuxfoundation.org, joe@perches.com, s.munaut@whatever-company.com, stable@vger.kernel.org


The patch titled
     Subject: printk: fix incorrect length from print_time() when seconds > 99999
has been added to the -mm tree.  Its filename is
     printk-fix-incorrect-length-from-print_time-when-seconds-99999.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -871,10 +871,11 @@ static size_t print_time(u64 ts, char *b
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

printk-fix-incorrect-length-from-print_time-when-seconds-99999.patch

