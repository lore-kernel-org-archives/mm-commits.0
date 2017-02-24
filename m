From: akpm@linux-foundation.org
Subject: [patch 096/124] proc: less code duplication in /proc/*/cmdline
Date: Fri, 24 Feb 2017 15:00:20 -0800
Message-ID: <58b0bb04.zwfXS5T0VF3iZBR8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdBXXAW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: less code duplication in /proc/*/cmdline

After staring at this code for a while I've figured using small 2-entry array
describing ARGV and ENVP is the way to address code duplication critique.

Link: http://lkml.kernel.org/r/20170105185724.GA12027@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |  142 ++++++++++++++++++-----------------------------
 1 file changed, 55 insertions(+), 87 deletions(-)

diff -puN fs/proc/base.c~proc-less-code-duplication-in-proc-cmdline fs/proc/base.c
--- a/fs/proc/base.c~proc-less-code-duplication-in-proc-cmdline
+++ a/fs/proc/base.c
@@ -292,101 +292,69 @@ static ssize_t proc_pid_cmdline_read(str
 		}
 	} else {
 		/*
-		 * Command line (1 string) occupies ARGV and maybe
-		 * extends into ENVP.
-		 */
-		if (len1 + len2 <= *pos)
-			goto skip_argv_envp;
-		if (len1 <= *pos)
-			goto skip_argv;
-
-		p = arg_start + *pos;
-		len = len1 - *pos;
-		while (count > 0 && len > 0) {
-			unsigned int _count, l;
-			int nr_read;
-			bool final;
-
-			_count = min3(count, len, PAGE_SIZE);
-			nr_read = access_remote_vm(mm, p, page, _count, 0);
-			if (nr_read < 0)
-				rv = nr_read;
-			if (nr_read <= 0)
-				goto out_free_page;
-
-			/*
-			 * Command line can be shorter than whole ARGV
-			 * even if last "marker" byte says it is not.
-			 */
-			final = false;
-			l = strnlen(page, nr_read);
-			if (l < nr_read) {
-				nr_read = l;
-				final = true;
-			}
-
-			if (copy_to_user(buf, page, nr_read)) {
-				rv = -EFAULT;
-				goto out_free_page;
-			}
-
-			p	+= nr_read;
-			len	-= nr_read;
-			buf	+= nr_read;
-			count	-= nr_read;
-			rv	+= nr_read;
-
-			if (final)
-				goto out_free_page;
-		}
-skip_argv:
-		/*
 		 * Command line (1 string) occupies ARGV and
 		 * extends into ENVP.
 		 */
-		if (len1 <= *pos) {
-			p = env_start + *pos - len1;
-			len = len1 + len2 - *pos;
-		} else {
-			p = env_start;
-			len = len2;
+		struct {
+			unsigned long p;
+			unsigned long len;
+		} cmdline[2] = {
+			{ .p = arg_start, .len = len1 },
+			{ .p = env_start, .len = len2 },
+		};
+		loff_t pos1 = *pos;
+		unsigned int i;
+
+		i = 0;
+		while (i < 2 && pos1 >= cmdline[i].len) {
+			pos1 -= cmdline[i].len;
+			i++;
 		}
-		while (count > 0 && len > 0) {
-			unsigned int _count, l;
-			int nr_read;
-			bool final;
-
-			_count = min3(count, len, PAGE_SIZE);
-			nr_read = access_remote_vm(mm, p, page, _count, 0);
-			if (nr_read < 0)
-				rv = nr_read;
-			if (nr_read <= 0)
-				goto out_free_page;
-
-			/* Find EOS. */
-			final = false;
-			l = strnlen(page, nr_read);
-			if (l < nr_read) {
-				nr_read = l;
-				final = true;
-			}
+		while (i < 2) {
+			p = cmdline[i].p + pos1;
+			len = cmdline[i].len - pos1;
+			while (count > 0 && len > 0) {
+				unsigned int _count, l;
+				int nr_read;
+				bool final;
+
+				_count = min3(count, len, PAGE_SIZE);
+				nr_read = access_remote_vm(mm, p, page, _count, 0);
+				if (nr_read < 0)
+					rv = nr_read;
+				if (nr_read <= 0)
+					goto out_free_page;
+
+				/*
+				 * Command line can be shorter than whole ARGV
+				 * even if last "marker" byte says it is not.
+				 */
+				final = false;
+				l = strnlen(page, nr_read);
+				if (l < nr_read) {
+					nr_read = l;
+					final = true;
+				}
+
+				if (copy_to_user(buf, page, nr_read)) {
+					rv = -EFAULT;
+					goto out_free_page;
+				}
+
+				p	+= nr_read;
+				len	-= nr_read;
+				buf	+= nr_read;
+				count	-= nr_read;
+				rv	+= nr_read;
 
-			if (copy_to_user(buf, page, nr_read)) {
-				rv = -EFAULT;
-				goto out_free_page;
+				if (final)
+					goto out_free_page;
 			}
 
-			p	+= nr_read;
-			len	-= nr_read;
-			buf	+= nr_read;
-			count	-= nr_read;
-			rv	+= nr_read;
