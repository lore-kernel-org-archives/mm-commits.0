From: akpm@linux-foundation.org
Subject: + cifs-switch-to-seq_files.patch added to -mm tree
Date: Fri, 09 May 2008 12:46:07 -0700
Message-ID: <200805091946.m49Jk7ag022724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbYEITvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 15:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, sfrench@us.ibm.com


The patch titled
     cifs: switch to seq_files
has been added to the -mm tree.  Its filename is
     cifs-switch-to-seq_files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: switch to seq_files
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_debug.c |  636 +++++++++++++++--------------------------
 1 file changed, 241 insertions(+), 395 deletions(-)

diff -puN fs/cifs/cifs_debug.c~cifs-switch-to-seq_files fs/cifs/cifs_debug.c
--- a/fs/cifs/cifs_debug.c~cifs-switch-to-seq_files
+++ a/fs/cifs/cifs_debug.c
@@ -107,9 +107,7 @@ void cifs_dump_mids(struct TCP_Server_In
 #endif /* CONFIG_CIFS_DEBUG2 */
 
 #ifdef CONFIG_PROC_FS
-static int
-cifs_debug_data_read(char *buf, char **beginBuffer, off_t offset,
-		     int count, int *eof, void *data)
+static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
 	struct list_head *tmp;
 	struct list_head *tmp1;
@@ -117,23 +115,13 @@ cifs_debug_data_read(char *buf, char **b
 	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
 	int i;
-	int length = 0;
-	char *original_buf = buf;
 
-	*beginBuffer = buf + offset;
-
-	length =
-	    sprintf(buf,
+	seq_puts(m,
 		    "Display Internal CIFS Data Structures for Debugging\n"
 		    "---------------------------------------------------\n");
-	buf += length;
-	length = sprintf(buf, "CIFS Version %s\n", CIFS_VERSION);
-	buf += length;
-	length = sprintf(buf,
-		"Active VFS Requests: %d\n", GlobalTotalActiveXid);
-	buf += length;
-	length = sprintf(buf, "Servers:");
-	buf += length;
+	seq_printf(m, "CIFS Version %s\n", CIFS_VERSION);
+	seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
+	seq_printf(m, "Servers:");
 
 	i = 0;
 	read_lock(&GlobalSMBSeslock);
@@ -142,11 +130,10 @@ cifs_debug_data_read(char *buf, char **b
 		ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
 		if ((ses->serverDomain == NULL) || (ses->serverOS == NULL) ||
 		   (ses->serverNOS == NULL)) {
-			buf += sprintf(buf, "\nentry for %s not fully "
+			seq_printf(m, "\nentry for %s not fully "
 					"displayed\n\t", ses->serverName);
 		} else {
-			length =
-			    sprintf(buf,
+			seq_printf(m,
 				    "\n%d) Name: %s  Domain: %s Mounts: %d OS:"
 				    " %s  \n\tNOS: %s\tCapability: 0x%x\n\tSMB"
 				    " session status: %d\t",
@@ -154,10 +141,9 @@ cifs_debug_data_read(char *buf, char **b
 				atomic_read(&ses->inUse),
 				ses->serverOS, ses->serverNOS,
 				ses->capabilities, ses->status);
-			buf += length;
 		}
 		if (ses->server) {
-			buf += sprintf(buf, "TCP status: %d\n\tLocal Users To "
+			seq_printf(m, "TCP status: %d\n\tLocal Users To "
 				    "Server: %d SecMode: 0x%x Req On Wire: %d",
 				ses->server->tcpStatus,
 				atomic_read(&ses->server->socketUseCount),
@@ -165,13 +151,12 @@ cifs_debug_data_read(char *buf, char **b
 				atomic_read(&ses->server->inFlight));
 
 #ifdef CONFIG_CIFS_STATS2
-			buf += sprintf(buf, " In Send: %d In MaxReq Wait: %d",
+			seq_printf(m, " In Send: %d In MaxReq Wait: %d",
 				atomic_read(&ses->server->inSend),
 				atomic_read(&ses->server->num_waiters));
 #endif
 
-			length = sprintf(buf, "\nMIDs:\n");
-			buf += length;
+			seq_puts(m, "\nMIDs:\n");
 
 			spin_lock(&GlobalMid_Lock);
 			list_for_each(tmp1, &ses->server->pending_mid_q) {
@@ -179,7 +164,7 @@ cifs_debug_data_read(char *buf, char **b
 					mid_q_entry,
 					qhead);
 				if (mid_entry) {
-					length = sprintf(buf,
+					seq_printf(m,
 							"State: %d com: %d pid:"
 							" %d tsk: %p mid %d\n",
 							mid_entry->midState,
@@ -187,7 +172,6 @@ cifs_debug_data_read(char *buf, char **b
 							mid_entry->pid,
 							mid_entry->tsk,
 							mid_entry->mid);
-					buf += length;
 				}
 			}
 			spin_unlock(&GlobalMid_Lock);
@@ -195,11 +179,9 @@ cifs_debug_data_read(char *buf, char **b
 
 	}
 	read_unlock(&GlobalSMBSeslock);
-	sprintf(buf, "\n");
-	buf++;
+	seq_putc(m, '\n');
 
-	length = sprintf(buf, "Shares:");
-	buf += length;
+	seq_puts(m, "Shares:");
 
 	i = 0;
 	read_lock(&GlobalSMBSeslock);
@@ -208,62 +190,52 @@ cifs_debug_data_read(char *buf, char **b
 		i++;
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
 		dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
-		length = sprintf(buf, "\n%d) %s Uses: %d ", i,
+		seq_printf(m, "\n%d) %s Uses: %d ", i,
 				 tcon->treeName, atomic_read(&tcon->useCount));
-		buf += length;
 		if (tcon->nativeFileSystem) {
-			length = sprintf(buf, "Type: %s ",
+			seq_printf(m, "Type: %s ",
 					 tcon->nativeFileSystem);
-			buf += length;
 		}
-		length = sprintf(buf, "DevInfo: 0x%x Attributes: 0x%x"
+		seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
 				 "\nPathComponentMax: %d Status: %d",
 			    le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
 			    le32_to_cpu(tcon->fsAttrInfo.Attributes),
 			    le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
 			    tcon->tidStatus);
-		buf += length;
 		if (dev_type == FILE_DEVICE_DISK)
-			length = sprintf(buf, " type: DISK ");
+			seq_puts(m, " type: DISK ");
 		else if (dev_type == FILE_DEVICE_CD_ROM)
-			length = sprintf(buf, " type: CDROM ");
+			seq_puts(m, " type: CDROM ");
 		else
-			length =
-			    sprintf(buf, " type: %d ", dev_type);
-		buf += length;
+			seq_printf(m, " type: %d ", dev_type);
 		if (tcon->tidStatus == CifsNeedReconnect) {
-			buf += sprintf(buf, "\tDISCONNECTED ");
-			length += 14;
+			seq_puts(m, "\tDISCONNECTED ");
 		}
 	}
 	read_unlock(&GlobalSMBSeslock);
 
-	length = sprintf(buf, "\n");
-	buf += length;
+	seq_putc(m, '\n');
 
 	/* BB add code to dump additional info such as TCP session info now */
-	/* Now calculate total size of returned data */
-	length = buf - original_buf;
-
-	if (offset + count >= length)
-		*eof = 1;
-	if (length < offset) {
-		*eof = 1;
-		return 0;
-	} else {
-		length = length - offset;
-	}
-	if (length > count)
-		length = count;
+	return 0;
+}
 
-	return length;
+static int cifs_debug_data_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_debug_data_proc_show, NULL);
 }
 
-#ifdef CONFIG_CIFS_STATS
+static const struct file_operations cifs_debug_data_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_debug_data_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-static int
-cifs_stats_write(struct file *file, const char __user *buffer,
-		 unsigned long count, void *data)
+#ifdef CONFIG_CIFS_STATS
+static ssize_t cifs_stats_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -307,236 +279,127 @@ cifs_stats_write(struct file *file, cons
 	return count;
 }
 
-static int
-cifs_stats_read(char *buf, char **beginBuffer, off_t offset,
-		  int count, int *eof, void *data)
+static int cifs_stats_proc_show(struct seq_file *m, void *v)
 {
-	int item_length, i, length;
+	int i;
 	struct list_head *tmp;
 	struct cifsTconInfo *tcon;
 
-	*beginBuffer = buf + offset;
-
-	length = sprintf(buf,
+	seq_printf(m,
 			"Resources in use\nCIFS Session: %d\n",
 			sesInfoAllocCount.counter);
-	buf += length;
-	item_length =
-		sprintf(buf, "Share (unique mount targets): %d\n",
+	seq_printf(m, "Share (unique mount targets): %d\n",
 			tconInfoAllocCount.counter);
-	length += item_length;
-	buf += item_length;
-	item_length =
-		sprintf(buf, "SMB Request/Response Buffer: %d Pool size: %d\n",
+	seq_printf(m, "SMB Request/Response Buffer: %d Pool size: %d\n",
 			bufAllocCount.counter,
 			cifs_min_rcv + tcpSesAllocCount.counter);
-	length += item_length;
-	buf += item_length;
-	item_length =
-		sprintf(buf, "SMB Small Req/Resp Buffer: %d Pool size: %d\n",
+	seq_printf(m, "SMB Small Req/Resp Buffer: %d Pool size: %d\n",
 			smBufAllocCount.counter, cifs_min_small);
-	length += item_length;
-	buf += item_length;
 #ifdef CONFIG_CIFS_STATS2
-	item_length = sprintf(buf, "Total Large %d Small %d Allocations\n",
+	seq_printf(m, "Total Large %d Small %d Allocations\n",
 				atomic_read(&totBufAllocCount),
 				atomic_read(&totSmBufAllocCount));
-	length += item_length;
-	buf += item_length;
 #endif /* CONFIG_CIFS_STATS2 */
 
-	item_length =
-		sprintf(buf, "Operations (MIDs): %d\n",
-			midCount.counter);
-	length += item_length;
-	buf += item_length;
-	item_length = sprintf(buf,
+	seq_printf(m, "Operations (MIDs): %d\n", midCount.counter);
+	seq_printf(m,
 		"\n%d session %d share reconnects\n",
 		tcpSesReconnectCount.counter, tconInfoReconnectCount.counter);
-	length += item_length;
-	buf += item_length;
 
-	item_length = sprintf(buf,
+	seq_printf(m,
 		"Total vfs operations: %d maximum at one time: %d\n",
 		GlobalCurrentXid, GlobalMaxActiveXid);
-	length += item_length;
-	buf += item_length;
 
 	i = 0;
 	read_lock(&GlobalSMBSeslock);
 	list_for_each(tmp, &GlobalTreeConnectionList) {
 		i++;
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		item_length = sprintf(buf, "\n%d) %s", i, tcon->treeName);
-		buf += item_length;
-		length += item_length;
-		if (tcon->tidStatus == CifsNeedReconnect) {
-			buf += sprintf(buf, "\tDISCONNECTED ");
-			length += 14;
-		}
-		item_length = sprintf(buf, "\nSMBs: %d Oplock Breaks: %d",
+		seq_printf(m, "\n%d) %s", i, tcon->treeName);
+		if (tcon->tidStatus == CifsNeedReconnect)
+			seq_puts(m, "\tDISCONNECTED ");
+		seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
 			atomic_read(&tcon->num_smbs_sent),
 			atomic_read(&tcon->num_oplock_brks));
-		buf += item_length;
-		length += item_length;
-		item_length = sprintf(buf, "\nReads:  %d Bytes: %lld",
+		seq_printf(m, "\nReads:  %d Bytes: %lld",
 			atomic_read(&tcon->num_reads),
 			(long long)(tcon->bytes_read));
-		buf += item_length;
-		length += item_length;
-		item_length = sprintf(buf, "\nWrites: %d Bytes: %lld",
+		seq_printf(m, "\nWrites: %d Bytes: %lld",
 			atomic_read(&tcon->num_writes),
 			(long long)(tcon->bytes_written));
-		buf += item_length;
-		length += item_length;
-		item_length = sprintf(buf,
+		seq_printf(m,
 			"\nLocks: %d HardLinks: %d Symlinks: %d",
 			atomic_read(&tcon->num_locks),
 			atomic_read(&tcon->num_hardlinks),
 			atomic_read(&tcon->num_symlinks));
-		buf += item_length;
-		length += item_length;
 
-		item_length = sprintf(buf, "\nOpens: %d Closes: %d Deletes: %d",
+		seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d",
 			atomic_read(&tcon->num_opens),
 			atomic_read(&tcon->num_closes),
 			atomic_read(&tcon->num_deletes));
-		buf += item_length;
-		length += item_length;
-		item_length = sprintf(buf, "\nMkdirs: %d Rmdirs: %d",
+		seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
 			atomic_read(&tcon->num_mkdirs),
 			atomic_read(&tcon->num_rmdirs));
-		buf += item_length;
-		length += item_length;
-		item_length = sprintf(buf, "\nRenames: %d T2 Renames %d",
+		seq_printf(m, "\nRenames: %d T2 Renames %d",
 			atomic_read(&tcon->num_renames),
 			atomic_read(&tcon->num_t2renames));
-		buf += item_length;
-		length += item_length;
-		item_length = sprintf(buf, "\nFindFirst: %d FNext %d FClose %d",
+		seq_printf(m, "\nFindFirst: %d FNext %d FClose %d",
 			atomic_read(&tcon->num_ffirst),
 			atomic_read(&tcon->num_fnext),
 			atomic_read(&tcon->num_fclose));
-		buf += item_length;
-		length += item_length;
 	}
 	read_unlock(&GlobalSMBSeslock);
 
-	buf += sprintf(buf, "\n");
-	length++;
-
-	if (offset + count >= length)
-		*eof = 1;
-	if (length < offset) {
-		*eof = 1;
-		return 0;
-	} else {
-		length = length - offset;
-	}
-	if (length > count)
-		length = count;
+	seq_putc(m, '\n');
+	return 0;
+}
 
-	return length;
+static int cifs_stats_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_stats_proc_show, NULL);
 }
+
+static const struct file_operations cifs_stats_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_stats_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifs_stats_proc_write,
+};
 #endif /* STATS */
 
 static struct proc_dir_entry *proc_fs_cifs;
-read_proc_t cifs_txanchor_read;
-static read_proc_t cifsFYI_read;
-static write_proc_t cifsFYI_write;
-static read_proc_t oplockEnabled_read;
-static write_proc_t oplockEnabled_write;
-static read_proc_t lookupFlag_read;
-static write_proc_t lookupFlag_write;
-static read_proc_t traceSMB_read;
-static write_proc_t traceSMB_write;
-static read_proc_t multiuser_mount_read;
-static write_proc_t multiuser_mount_write;
-static read_proc_t security_flags_read;
-static write_proc_t security_flags_write;
-/* static read_proc_t ntlmv2_enabled_read;
-static write_proc_t ntlmv2_enabled_write;
-static read_proc_t packet_signing_enabled_read;
-static write_proc_t packet_signing_enabled_write;*/
-static read_proc_t experimEnabled_read;
-static write_proc_t experimEnabled_write;
-static read_proc_t linuxExtensionsEnabled_read;
-static write_proc_t linuxExtensionsEnabled_write;
+static const struct file_operations cifsFYI_proc_fops;
+static const struct file_operations cifs_oplock_proc_fops;
+static const struct file_operations cifs_lookup_cache_proc_fops;
+static const struct file_operations traceSMB_proc_fops;
+static const struct file_operations cifs_multiuser_mount_proc_fops;
+static const struct file_operations cifs_security_flags_proc_fops;
+static const struct file_operations cifs_experimental_proc_fops;
+static const struct file_operations cifs_linux_ext_proc_fops;
 
 void
 cifs_proc_init(void)
 {
-	struct proc_dir_entry *pde;
-
 	proc_fs_cifs = proc_mkdir("fs/cifs", NULL);
 	if (proc_fs_cifs == NULL)
 		return;
 
 	proc_fs_cifs->owner = THIS_MODULE;
-	create_proc_read_entry("DebugData", 0, proc_fs_cifs,
-				cifs_debug_data_read, NULL);
+	proc_create("DebugData", 0, proc_fs_cifs, &cifs_debug_data_proc_fops);
 
 #ifdef CONFIG_CIFS_STATS
-	pde = create_proc_read_entry("Stats", 0, proc_fs_cifs,
-				cifs_stats_read, NULL);
-	if (pde)
-		pde->write_proc = cifs_stats_write;
+	proc_create("Stats", 0, proc_fs_cifs, &cifs_stats_proc_fops);
 #endif /* STATS */
-	pde = create_proc_read_entry("cifsFYI", 0, proc_fs_cifs,
-				cifsFYI_read, NULL);
-	if (pde)
-		pde->write_proc = cifsFYI_write;
-
-	pde =
-	    create_proc_read_entry("traceSMB", 0, proc_fs_cifs,
-				traceSMB_read, NULL);
-	if (pde)
-		pde->write_proc = traceSMB_write;
-
-	pde = create_proc_read_entry("OplockEnabled", 0, proc_fs_cifs,
-				oplockEnabled_read, NULL);
-	if (pde)
-		pde->write_proc = oplockEnabled_write;
-
-	pde = create_proc_read_entry("Experimental", 0, proc_fs_cifs,
-				experimEnabled_read, NULL);
-	if (pde)
-		pde->write_proc = experimEnabled_write;
-
-	pde = create_proc_read_entry("LinuxExtensionsEnabled", 0, proc_fs_cifs,
-				linuxExtensionsEnabled_read, NULL);
-	if (pde)
-		pde->write_proc = linuxExtensionsEnabled_write;
-
-	pde =
-	    create_proc_read_entry("MultiuserMount", 0, proc_fs_cifs,
-				multiuser_mount_read, NULL);
-	if (pde)
-		pde->write_proc = multiuser_mount_write;
-
-	pde =
-	    create_proc_read_entry("SecurityFlags", 0, proc_fs_cifs,
-				security_flags_read, NULL);
-	if (pde)
-		pde->write_proc = security_flags_write;
-
-	pde =
-	create_proc_read_entry("LookupCacheEnabled", 0, proc_fs_cifs,
-				lookupFlag_read, NULL);
-	if (pde)
-		pde->write_proc = lookupFlag_write;
-
-/*	pde =
-	    create_proc_read_entry("NTLMV2Enabled", 0, proc_fs_cifs,
-				ntlmv2_enabled_read, NULL);
-	if (pde)
-		pde->write_proc = ntlmv2_enabled_write;
-
-	pde =
-	    create_proc_read_entry("PacketSigningEnabled", 0, proc_fs_cifs,
-				packet_signing_enabled_read, NULL);
-	if (pde)
-		pde->write_proc = packet_signing_enabled_write;*/
+	proc_create("cifsFYI", 0, proc_fs_cifs, &cifsFYI_proc_fops);
+	proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_proc_fops);
+	proc_create("OplockEnabled", 0, proc_fs_cifs, &cifs_oplock_proc_fops);
+	proc_create("Experimental", 0, proc_fs_cifs, &cifs_experimental_proc_fops);
+	proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs, &cifs_linux_ext_proc_fops);
+	proc_create("MultiuserMount", 0, proc_fs_cifs, &cifs_multiuser_mount_proc_fops);
+	proc_create("SecurityFlags", 0, proc_fs_cifs, &cifs_security_flags_proc_fops);
+	proc_create("LookupCacheEnabled", 0, proc_fs_cifs, &cifs_lookup_cache_proc_fops);
 }
 
 void
@@ -553,39 +416,26 @@ cifs_proc_clean(void)
 #endif
 	remove_proc_entry("MultiuserMount", proc_fs_cifs);
 	remove_proc_entry("OplockEnabled", proc_fs_cifs);
-/*	remove_proc_entry("NTLMV2Enabled",proc_fs_cifs); */
 	remove_proc_entry("SecurityFlags", proc_fs_cifs);
-/*	remove_proc_entry("PacketSigningEnabled", proc_fs_cifs); */
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
 	remove_proc_entry("Experimental", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
 	remove_proc_entry("fs/cifs", NULL);
 }
 
-static int
-cifsFYI_read(char *page, char **start, off_t off, int count,
-	     int *eof, void *data)
+static int cifsFYI_proc_show(struct seq_file *m, void *v)
 {
-	int len;
-
-	len = sprintf(page, "%d\n", cifsFYI);
-
-	len -= off;
-	*start = page + off;
-
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
+	seq_printf(m, "%d\n", cifsFYI);
+	return 0;
+}
 
-	return len;
+static int cifsFYI_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifsFYI_proc_show, NULL);
 }
-static int
-cifsFYI_write(struct file *file, const char __user *buffer,
-	      unsigned long count, void *data)
+
+static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -603,30 +453,28 @@ cifsFYI_write(struct file *file, const c
 	return count;
 }
 
-static int
-oplockEnabled_read(char *page, char **start, off_t off,
-		   int count, int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "%d\n", oplockEnabled);
-
-	len -= off;
-	*start = page + off;
-
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
+static const struct file_operations cifsFYI_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifsFYI_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifsFYI_proc_write,
+};
 
-	if (len < 0)
-		len = 0;
+static int cifs_oplock_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", oplockEnabled);
+	return 0;
+}
 
-	return len;
+static int cifs_oplock_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_oplock_proc_show, NULL);
 }
-static int
-oplockEnabled_write(struct file *file, const char __user *buffer,
-		    unsigned long count, void *data)
+
+static ssize_t cifs_oplock_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -642,30 +490,28 @@ oplockEnabled_write(struct file *file, c
 	return count;
 }
 
-static int
-experimEnabled_read(char *page, char **start, off_t off,
-		    int count, int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "%d\n", experimEnabled);
-
-	len -= off;
-	*start = page + off;
+static const struct file_operations cifs_oplock_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_oplock_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifs_oplock_proc_write,
+};
 
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
+static int cifs_experimental_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", experimEnabled);
+	return 0;
+}
 
-	return len;
+static int cifs_experimental_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_experimental_proc_show, NULL);
 }
-static int
-experimEnabled_write(struct file *file, const char __user *buffer,
-		     unsigned long count, void *data)
+
+static ssize_t cifs_experimental_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -683,29 +529,28 @@ experimEnabled_write(struct file *file, 
 	return count;
 }
 
-static int
-linuxExtensionsEnabled_read(char *page, char **start, off_t off,
-			    int count, int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "%d\n", linuxExtEnabled);
-	len -= off;
-	*start = page + off;
+static const struct file_operations cifs_experimental_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_experimental_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifs_experimental_proc_write,
+};
 
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
+static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", linuxExtEnabled);
+	return 0;
+}
 
-	return len;
+static int cifs_linux_ext_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_linux_ext_proc_show, NULL);
 }
-static int
-linuxExtensionsEnabled_write(struct file *file, const char __user *buffer,
-			     unsigned long count, void *data)
+
+static ssize_t cifs_linux_ext_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -721,31 +566,28 @@ linuxExtensionsEnabled_write(struct file
 	return count;
 }
 
+static const struct file_operations cifs_linux_ext_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_linux_ext_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifs_linux_ext_proc_write,
+};
 
-static int
-lookupFlag_read(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int cifs_lookup_cache_proc_show(struct seq_file *m, void *v)
 {
-	int len;
-
-	len = sprintf(page, "%d\n", lookupCacheEnabled);
-
-	len -= off;
-	*start = page + off;
-
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
+	seq_printf(m, "%d\n", lookupCacheEnabled);
+	return 0;
+}
 
-	return len;
+static int cifs_lookup_cache_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_lookup_cache_proc_show, NULL);
 }
-static int
-lookupFlag_write(struct file *file, const char __user *buffer,
-		    unsigned long count, void *data)
+
+static ssize_t cifs_lookup_cache_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -760,30 +602,29 @@ lookupFlag_write(struct file *file, cons
 
 	return count;
 }
-static int
-traceSMB_read(char *page, char **start, off_t off, int count,
-	      int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "%d\n", traceSMB);
-
-	len -= off;
-	*start = page + off;
 
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
+static const struct file_operations cifs_lookup_cache_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_lookup_cache_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifs_lookup_cache_proc_write,
+};
 
-	if (len < 0)
-		len = 0;
+static int traceSMB_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", traceSMB);
+	return 0;
+}
 
-	return len;
+static int traceSMB_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, traceSMB_proc_show, NULL);
 }
-static int
-traceSMB_write(struct file *file, const char __user *buffer,
-	       unsigned long count, void *data)
+
+static ssize_t traceSMB_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -799,30 +640,28 @@ traceSMB_write(struct file *file, const 
 	return count;
 }
 
-static int
-multiuser_mount_read(char *page, char **start, off_t off,
-		     int count, int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "%d\n", multiuser_mount);
-
-	len -= off;
-	*start = page + off;
+static const struct file_operations traceSMB_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= traceSMB_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= traceSMB_proc_write,
+};
 
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
+static int cifs_multiuser_mount_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", multiuser_mount);
+	return 0;
+}
 
-	return len;
+static int cifs_multiuser_mount_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_multiuser_mount_proc_show, NULL);
 }
-static int
-multiuser_mount_write(struct file *file, const char __user *buffer,
-		      unsigned long count, void *data)
+
+static ssize_t cifs_multiuser_mount_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
 	int rc;
@@ -838,30 +677,28 @@ multiuser_mount_write(struct file *file,
 	return count;
 }
 
-static int
-security_flags_read(char *page, char **start, off_t off,
-		       int count, int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "0x%x\n", extended_security);
-
-	len -= off;
-	*start = page + off;
+static const struct file_operations cifs_multiuser_mount_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_multiuser_mount_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifs_multiuser_mount_proc_write,
+};
 
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
+static int cifs_security_flags_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "0x%x\n", extended_security);
+	return 0;
+}
 
-	return len;
+static int cifs_security_flags_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_security_flags_proc_show, NULL);
 }
-static int
-security_flags_write(struct file *file, const char __user *buffer,
-			unsigned long count, void *data)
+
+static ssize_t cifs_security_flags_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	unsigned int flags;
 	char flags_string[12];
@@ -917,6 +754,15 @@ security_flags_write(struct file *file, 
 	/* BB should we turn on MAY flags for other MUST options? */
 	return count;
 }
+
+static const struct file_operations cifs_security_flags_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cifs_security_flags_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cifs_security_flags_proc_write,
+};
 #else
 inline void cifs_proc_init(void)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
linux-next.patch
arm-lubbock-fix-compilation.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-block.patch
kbuild-escape-meta-characters-in-regular-expression-in-make-tags.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch
ext4-switch-to-seq_files.patch
cifs-switch-to-seq_files.patch
jfs-switch-to-seq_files.patch

