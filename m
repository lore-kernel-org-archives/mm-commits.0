From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-ip2-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:37 -0700
Message-ID: <200904011833.n31IXbLP006772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758391AbZDASgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch ip2 to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-ip2-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch ip2 to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   74 ++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 40 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~proc-tty-switch-ip2-to-proc_fops drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~proc-tty-switch-ip2-to-proc_fops
+++ a/drivers/char/ip2/ip2main.c
@@ -139,7 +139,7 @@
 #include <linux/seq_file.h>
 
 static const struct file_operations ip2mem_proc_fops;
-static int ip2_read_proc(char *, char **, off_t, int, int *, void * );
+static const struct file_operations ip2_proc_fops;
 
 /********************/
 /* Type Definitions */
@@ -446,9 +446,9 @@ static const struct tty_operations ip2_o
 	.stop            = ip2_stop,
 	.start           = ip2_start,
 	.hangup          = ip2_hangup,
-	.read_proc       = ip2_read_proc,
 	.tiocmget	 = ip2_tiocmget,
 	.tiocmset	 = ip2_tiocmset,
+	.proc_fops	 = &ip2_proc_fops,
 };
 
 /******************************************************************************/
@@ -3029,19 +3029,17 @@ static const struct file_operations ip2m
  * different sources including ip2mkdev.c and a couple of other drivers.
  * The bugs are all mine.  :-)	=mhw=
  */
-static int ip2_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
+static int ip2_proc_show(struct seq_file *m, void *v)
 {
 	int	i, j, box;
-	int	len = 0;
 	int	boxes = 0;
 	int	ports = 0;
 	int	tports = 0;
-	off_t	begin = 0;
 	i2eBordStrPtr  pB;
+	char *sep;
 
-	len += sprintf(page, "ip2info: 1.0 driver: %s\n", pcVersion );
-	len += sprintf(page+len, "Driver: SMajor=%d CMajor=%d IMajor=%d MaxBoards=%d MaxBoxes=%d MaxPorts=%d\n",
+	seq_printf(m, "ip2info: 1.0 driver: %s\n", pcVersion);
+	seq_printf(m, "Driver: SMajor=%d CMajor=%d IMajor=%d MaxBoards=%d MaxBoxes=%d MaxPorts=%d\n",
 			IP2_TTY_MAJOR, IP2_CALLOUT_MAJOR, IP2_IPL_MAJOR,
 			IP2_MAX_BOARDS, ABS_MAX_BOXES, ABS_BIGGEST_BOX);
 
@@ -3053,7 +3051,8 @@ static int ip2_read_proc(char *page, cha
 			switch( pB->i2ePom.e.porID & ~POR_ID_RESERVED ) 
 			{
 			case POR_ID_FIIEX:
-				len += sprintf( page+len, "Board %d: EX ports=", i );
+				seq_printf(m, "Board %d: EX ports=", i);
+				sep = "";
 				for( box = 0; box < ABS_MAX_BOXES; ++box )
 				{
 					ports = 0;
@@ -3065,79 +3064,74 @@ static int ip2_read_proc(char *page, cha
 							++ports;
 						}
 					}
-					len += sprintf( page+len, "%d,", ports );
+					seq_printf(m, "%s%d", sep, ports);
+					sep = ",";
 					tports += ports;
 				}
-
-				--len;	/* Backup over that last comma */
-
-				len += sprintf( page+len, " boxes=%d width=%d", boxes, pB->i2eDataWidth16 ? 16 : 8 );
+				seq_printf(m, " boxes=%d width=%d", boxes, pB->i2eDataWidth16 ? 16 : 8);
 				break;
 
 			case POR_ID_II_4:
-				len += sprintf(page+len, "Board %d: ISA-4 ports=4 boxes=1", i );
+				seq_printf(m, "Board %d: ISA-4 ports=4 boxes=1", i);
 				tports = ports = 4;
 				break;
 
 			case POR_ID_II_8:
-				len += sprintf(page+len, "Board %d: ISA-8-std ports=8 boxes=1", i );
+				seq_printf(m, "Board %d: ISA-8-std ports=8 boxes=1", i);
 				tports = ports = 8;
 				break;
 
 			case POR_ID_II_8R:
-				len += sprintf(page+len, "Board %d: ISA-8-RJ11 ports=8 boxes=1", i );
+				seq_printf(m, "Board %d: ISA-8-RJ11 ports=8 boxes=1", i);
 				tports = ports = 8;
 				break;
 
 			default:
-				len += sprintf(page+len, "Board %d: unknown", i );
+				seq_printf(m, "Board %d: unknown", i);
 				/* Don't try and probe for minor numbers */
 				tports = ports = 0;
 			}
 
 		} else {
 			/* Don't try and probe for minor numbers */
-			len += sprintf(page+len, "Board %d: vacant", i );
+			seq_printf(m, "Board %d: vacant", i);
 			tports = ports = 0;
 		}
 
 		if( tports ) {
-			len += sprintf(page+len, " minors=" );
-
+			seq_puts(m, " minors=");
+			sep = "";
 			for ( box = 0; box < ABS_MAX_BOXES; ++box )
 			{
 				for ( j = 0; j < ABS_BIGGEST_BOX; ++j )
 				{
 					if ( pB->i2eChannelMap[box] & (1 << j) )
 					{
-						len += sprintf (page+len,"%d,",
+						seq_printf(m, "%s%d", sep,
 							j + ABS_BIGGEST_BOX *
 							(box+i*ABS_MAX_BOXES));
+						sep = ",";
 					}
 				}
 			}
-
-			page[ len - 1 ] = '\n';	/* Overwrite that last comma */
-		} else {
-			len += sprintf (page+len,"\n" );
-		}
-
-		if (len+begin > off+count)
-			break;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
 		}
+		seq_putc(m, '\n');
 	}
+	return 0;
+ }
 
-	if (i >= IP2_MAX_BOARDS)
-		*eof = 1;
-	if (off >= len+begin)
-		return 0;
+static int ip2_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ip2_proc_show, NULL);
+}
 
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
- }
+static const struct file_operations ip2_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ip2_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
  
 /******************************************************************************/
 /* Function:   ip2trace()                                                     */
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

