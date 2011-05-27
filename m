From: akpm@linux-foundation.org
Subject: [to-be-updated] coredump-escape-in-hostname-and-comm.patch removed from -mm tree
Date: Fri, 27 May 2011 12:54:29 -0700
Message-ID: <201105271952.p4RJqZVj017212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1E0Twv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     coredump: escape / in hostname and comm
has been removed from the -mm tree.  Its filename was
     coredump-escape-in-hostname-and-comm.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: escape / in hostname and comm
From: Jiri Slaby <jslaby@suse.cz>

Change every occurence of / in comm and hostname to !.  If the process
changes its name to contain /, the core is not dumped (if the directory
tree doesn't exist like that).  The same with hostname being something
like myhost/3.  Fix this behaviour by using the escape loop used in %E. 
(We extract it to a separate function.)

Now both with comm == myprocess/1 and hostname == myhost/1, the core is
dumped like (kernel.core_pattern='core.%p.%e.%h):
core.2349.myprocess!1.myhost!1

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff -puN fs/exec.c~coredump-escape-in-hostname-and-comm fs/exec.c
--- a/fs/exec.c~coredump-escape-in-hostname-and-comm
+++ a/fs/exec.c
@@ -1623,17 +1623,24 @@ expand_fail:
 	return ret;
 }
 
+static void cn_escape(char *str)
+{
+	for (; *str; str++)
+		if (*str == '/')
+			*str = '!';
+}
+
 static int cn_print_exe_file(struct core_name *cn)
 {
 	struct file *exe_file;
-	char *pathbuf, *path, *p;
+	char *pathbuf, *path;
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file) {
 		char comm[TASK_COMM_LEN];
-		return cn_printf(cn, "%s (path unknown)", get_task_comm(comm,
-					current));
+		cn_escape(get_task_comm(comm, current));
+		return cn_printf(cn, "%s (path unknown)", comm);
 	}
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
@@ -1648,9 +1655,7 @@ static int cn_print_exe_file(struct core
 		goto free_buf;
 	}
 
-	for (p = path; *p; p++)
-		if (*p == '/')
-			*p = '!';
+	cn_escape(path);
 
 	ret = cn_printf(cn, "%s", path);
 
@@ -1722,17 +1727,20 @@ static int format_corename(struct core_n
 				break;
 			}
 			/* hostname */
-			case 'h':
+			case 'h': {
+				char *namestart = cn->corename + cn->used;
 				down_read(&uts_sem);
 				err = cn_printf(cn, "%s",
 					      utsname()->nodename);
 				up_read(&uts_sem);
+				cn_escape(namestart);
 				break;
+			}
 			/* executable */
 			case 'e': {
 				char comm[TASK_COMM_LEN];
-				err = cn_printf(cn, "%s",
-						get_task_comm(comm, current));
+				cn_escape(get_task_comm(comm, current));
+				err = cn_printf(cn, "%s", comm);
 				break;
 			}
 			case 'E':
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
coredump-use-task-comm-instead-of-unknown.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

