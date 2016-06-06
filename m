From: akpm@linux-foundation.org
Subject: [merged]
 kdump-fix-dmesg-gdbmacro-to-work-with-record-based-printk.patch removed
 from -mm tree
Date: Mon, 06 Jun 2016 12:06:41 -0700
Message-ID: <5755c9c1.MBUhDf3nOv9oNo+d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbcFFTGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 15:06:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, bhe@redhat.com, dyoung@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: fix dmesg gdbmacro to work with record based printk
has been removed from the -mm tree.  Its filename was
     kdump-fix-dmesg-gdbmacro-to-work-with-record-based-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: kdump: fix dmesg gdbmacro to work with record based printk

7ff9554bb578ba02 ("printk: convert byte-buffer to variable-length record
buffer") introduced a record based printk buffer.  Modify gdbmacros.txt to
parse this new structure so dmesg will work properly.

Link: http://lkml.kernel.org/r/1463515794-1599-1-git-send-email-minyard@acm.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/gdbmacros.txt |   93 ++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 11 deletions(-)

diff -puN Documentation/kdump/gdbmacros.txt~kdump-fix-dmesg-gdbmacro-to-work-with-record-based-printk Documentation/kdump/gdbmacros.txt
--- a/Documentation/kdump/gdbmacros.txt~kdump-fix-dmesg-gdbmacro-to-work-with-record-based-printk
+++ a/Documentation/kdump/gdbmacros.txt
@@ -170,21 +170,92 @@ document trapinfo
 	address the kernel panicked.
 end
 
+define dump_log_idx
+	set $idx = $arg0
+	if ($argc > 1)
+		set $prev_flags = $arg1
+	else
+		set $prev_flags = 0
+	end
+	set $msg = ((struct printk_log *) (log_buf + $idx))
+	set $prefix = 1
+	set $newline = 1
+	set $log = log_buf + $idx + sizeof(*$msg)
 
-define dmesg
-	set $i = 0
-	set $end_idx = (log_end - 1) & (log_buf_len - 1)
+	# prev & LOG_CONT && !(msg->flags & LOG_PREIX)
+	if (($prev_flags & 8) && !($msg->flags & 4))
+		set $prefix = 0
+	end
 
-	while ($i < logged_chars)
-		set $idx = (log_end - 1 - logged_chars + $i) & (log_buf_len - 1)
+	# msg->flags & LOG_CONT
+	if ($msg->flags & 8)
+		# (prev & LOG_CONT && !(prev & LOG_NEWLINE))
+		if (($prev_flags & 8) && !($prev_flags & 2))
+			set $prefix = 0
+		end
+		# (!(msg->flags & LOG_NEWLINE))
+		if (!($msg->flags & 2))
+			set $newline = 0
+		end
+	end
 
-		if ($idx + 100 <= $end_idx) || \
-		   ($end_idx <= $idx && $idx + 100 < log_buf_len)
-			printf "%.100s", &log_buf[$idx]
-			set $i = $i + 100
+	if ($prefix)
+		printf "[%5lu.%06lu] ", $msg->ts_nsec / 1000000000, $msg->ts_nsec % 1000000000
+	end
+	if ($msg->text_len != 0)
+		eval "printf \"%%%d.%ds\", $log", $msg->text_len, $msg->text_len
+	end
+	if ($newline)
+		printf "\n"
+	end
+	if ($msg->dict_len > 0)
+		set $dict = $log + $msg->text_len
+		set $idx = 0
+		set $line = 1
+		while ($idx < $msg->dict_len)
+			if ($line)
+				printf " "
+				set $line = 0
+			end
+			set $c = $dict[$idx]
+			if ($c == '\0')
+				printf "\n"
+				set $line = 1
+			else
+				if ($c < ' ' || $c >= 127 || $c == '\\')
+					printf "\\x%02x", $c
+				else
+					printf "%c", $c
+				end
+			end
+			set $idx = $idx + 1
+		end
+		printf "\n"
+	end
+end
+document dump_log_idx
+	Dump a single log given its index in the log buffer.  The first
+	parameter is the index into log_buf, the second is optional and
+	specified the previous log buffer's flags, used for properly
+	formatting continued lines.
+end
+
+define dmesg
+	set $i = log_first_idx
+	set $end_idx = log_first_idx
+	set $prev_flags = 0
+
+	while (1)
+		set $msg = ((struct printk_log *) (log_buf + $i))
+		if ($msg->len == 0)
+			set $i = 0
 		else
-			printf "%c", log_buf[$idx]
-			set $i = $i + 1
+			dump_log_idx $i $prev_flags
+			set $i = $i + $msg->len
+			set $prev_flags = $msg->flags
+		end
+		if ($i == $end_idx)
+			loop_break
 		end
 	end
 end
_

Patches currently in -mm which might be from cminyard@mvista.com are


