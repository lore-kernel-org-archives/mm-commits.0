From: akpm@linux-foundation.org
Subject: - cgroup-api-files-add-cgroup-map-data-type.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:21 -0700
Message-ID: <200804300542.m3U5gL3c029138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028AbYD3Fne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     CGroup API files: add cgroup map data type
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-add-cgroup-map-data-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: add cgroup map data type
From: Paul Menage <menage@google.com>

Adds a new type of supported control file representation, a map from strings
to u64 values.

Each map entry is printed as a line in a similar format to /proc/vmstat, i.e. 
"$key $value\n"

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   19 +++++++++++++
 kernel/cgroup.c        |   53 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff -puN include/linux/cgroup.h~cgroup-api-files-add-cgroup-map-data-type include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-api-files-add-cgroup-map-data-type
+++ a/include/linux/cgroup.h
@@ -166,6 +166,16 @@ struct css_set {
 
 };
 
+/*
+ * cgroup_map_cb is an abstract callback API for reporting map-valued
+ * control files
+ */
+
+struct cgroup_map_cb {
+	int (*fill)(struct cgroup_map_cb *cb, const char *key, u64 value);
+	void *state;
+};
+
 /* struct cftype:
  *
  * The files in the cgroup filesystem mostly have a very simple read/write
@@ -194,6 +204,15 @@ struct cftype {
 	 * single integer. Use it in place of read()
 	 */
 	u64 (*read_u64) (struct cgroup *cgrp, struct cftype *cft);
+	/*
+	 * read_map() is used for defining a map of key/value
+	 * pairs. It should call cb->fill(cb, key, value) for each
+	 * entry. The key/value pairs (and their ordering) should not
+	 * change between reboots.
+	 */
+	int (*read_map) (struct cgroup *cont, struct cftype *cft,
+			 struct cgroup_map_cb *cb);
+
 	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
 			  struct file *file,
 			  const char __user *buf, size_t nbytes, loff_t *ppos);
diff -puN kernel/cgroup.c~cgroup-api-files-add-cgroup-map-data-type kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-api-files-add-cgroup-map-data-type
+++ a/kernel/cgroup.c
@@ -1492,6 +1492,46 @@ static ssize_t cgroup_file_read(struct f
 	return -EINVAL;
 }
 
+/*
+ * seqfile ops/methods for returning structured data. Currently just
+ * supports string->u64 maps, but can be extended in future.
+ */
+
+struct cgroup_seqfile_state {
+	struct cftype *cft;
+	struct cgroup *cgroup;
+};
+
+static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
+{
+	struct seq_file *sf = cb->state;
+	return seq_printf(sf, "%s %llu\n", key, (unsigned long long)value);
+}
+
+static int cgroup_seqfile_show(struct seq_file *m, void *arg)
+{
+	struct cgroup_seqfile_state *state = m->private;
+	struct cftype *cft = state->cft;
+	struct cgroup_map_cb cb = {
+		.fill = cgroup_map_add,
+		.state = m,
+	};
+	return cft->read_map(state->cgroup, cft, &cb);
+}
+
+int cgroup_seqfile_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	kfree(seq->private);
+	return single_release(inode, file);
+}
+
+static struct file_operations cgroup_seqfile_operations = {
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = cgroup_seqfile_release,
+};
+
 static int cgroup_file_open(struct inode *inode, struct file *file)
 {
 	int err;
@@ -1504,7 +1544,18 @@ static int cgroup_file_open(struct inode
 	cft = __d_cft(file->f_dentry);
 	if (!cft)
 		return -ENODEV;
-	if (cft->open)
+	if (cft->read_map) {
+		struct cgroup_seqfile_state *state =
+			kzalloc(sizeof(*state), GFP_USER);
+		if (!state)
+			return -ENOMEM;
+		state->cft = cft;
+		state->cgroup = __d_cgrp(file->f_dentry->d_parent);
+		file->f_op = &cgroup_seqfile_operations;
+		err = single_open(file, cgroup_seqfile_show, state);
+		if (err < 0)
+			kfree(state);
+	} else if (cft->open)
 		err = cft->open(inode, file);
 	else
 		err = 0;
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch

