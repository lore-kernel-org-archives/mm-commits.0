From: akpm@linux-foundation.org
Subject: + coredump-escape-in-hostname-and-comm.patch added to -mm tree
Date: Thu, 12 May 2011 12:30:46 -0700
Message-ID: <201105121930.p4CJUkvc028529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971Ab1ELTkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 15:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, john.stultz@linaro.org


The patch titled
     coredump: escape / in hostname and comm
has been added to the -mm tree.  Its filename is
     coredump-escape-in-hostname-and-comm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/exec.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~coredump-escape-in-hostname-and-comm fs/exec.c
--- a/fs/exec.c~coredump-escape-in-hostname-and-comm
+++ a/fs/exec.c
@@ -1547,10 +1547,17 @@ expand_fail:
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
@@ -1572,9 +1579,7 @@ static int cn_print_exe_file(struct core
 		goto free_buf;
 	}
 
-	for (p = path; *p; p++)
-		if (*p == '/')
-			*p = '!';
+	cn_escape(path);
 
 	ret = cn_printf(cn, "%s", path);
 
@@ -1646,17 +1651,20 @@ static int format_corename(struct core_n
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

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mm-extract-exe_file-handling-from-procfs.patch
coredump-add-support-for-exe_file-in-core-name.patch
coredump-use-get_task_comm-for-%e-filename-format.patch
coredump-use-task-comm-instead-of-unknown.patch
coredump-escape-in-hostname-and-comm.patch

