From: akpm@linux-foundation.org
Subject: + parse_integer-convert-fs-ocfs2.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:25 -0700
Message-ID: <559ecae1.jbmE5nogd3bon9Kd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbbGIT00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jlbec@evilplan.org, linux@rasmusvillemoes.dk, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert fs/ocfs2/
has been added to the -mm tree.  Its filename is
     parse_integer-convert-fs-ocfs2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-fs-ocfs2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-fs-ocfs2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert fs/ocfs2/

Convert away from deprecated simple_strto*() interfaces.

Autodetection of value range from type allows to remove disgusting checks:

	if ((major == LONG_MIN) || (major == LONG_MAX) ||
	    (major > (u8)-1) || (major < 1))
	        return -ERANGE;
	if ((minor == LONG_MIN) || (minor == LONG_MAX) ||
	    (minor > (u8)-1) || (minor < 0))

Poof, they're gone!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c   |   54 +++++++++++++------------------
 fs/ocfs2/cluster/nodemanager.c |   50 ++++++++++++----------------
 fs/ocfs2/stack_user.c          |   52 ++++++++++++++---------------
 3 files changed, 71 insertions(+), 85 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~parse_integer-convert-fs-ocfs2 fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~parse_integer-convert-fs-ocfs2
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1453,13 +1453,12 @@ static int o2hb_read_block_input(struct
 				 unsigned long *ret_bytes,
 				 unsigned int *ret_bits)
 {
-	unsigned long bytes;
-	char *p = (char *)page;
-
-	bytes = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	unsigned int bytes;
+	int rv;
 
+	rv = kstrtouint(page, 0, &bytes);
+	if (rv < 0)
+		return rv;
 	/* Heartbeat and fs min / max block sizes are the same. */
 	if (bytes > 4096 || bytes < 512)
 		return -ERANGE;
@@ -1512,18 +1511,14 @@ static ssize_t o2hb_region_start_block_w
 					     const char *page,
 					     size_t count)
 {
-	unsigned long long tmp;
-	char *p = (char *)page;
+	int rv;
 
 	if (reg->hr_bdev)
 		return -EINVAL;
 
-	tmp = simple_strtoull(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
-
-	reg->hr_start_block = tmp;
-
+	rv = kstrtoull(page, 0, &reg->hr_start_block);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
@@ -1537,20 +1532,19 @@ static ssize_t o2hb_region_blocks_write(
 					const char *page,
 					size_t count)
 {
-	unsigned long tmp;
-	char *p = (char *)page;
+	unsigned int tmp;
+	int rv;
 
 	if (reg->hr_bdev)
 		return -EINVAL;
 
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
-
+	rv = kstrtouint(page, 0, &tmp);
+	if (rv < 0)
+		return rv;
 	if (tmp > O2NM_MAX_NODES || tmp == 0)
 		return -ERANGE;
 
-	reg->hr_blocks = (unsigned int)tmp;
+	reg->hr_blocks = tmp;
 
 	return count;
 }
@@ -1686,9 +1680,8 @@ static ssize_t o2hb_region_dev_write(str
 				     size_t count)
 {
 	struct task_struct *hb_task;
-	long fd;
+	int fd;
 	int sectsize;
-	char *p = (char *)page;
 	struct fd f;
 	struct inode *inode;
 	ssize_t ret = -EINVAL;
@@ -1702,10 +1695,9 @@ static ssize_t o2hb_region_dev_write(str
 	if (o2nm_this_node() == O2NM_MAX_NODES)
 		goto out;
 
-	fd = simple_strtol(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	ret = kstrtoint(page, 0, &fd);
+	if (ret < 0)
 		goto out;
-
 	if (fd < 0 || fd >= INT_MAX)
 		goto out;
 
@@ -2179,12 +2171,12 @@ static ssize_t o2hb_heartbeat_group_thre
 						    const char *page,
 						    size_t count)
 {
-	unsigned long tmp;
-	char *p = (char *)page;
+	unsigned int tmp;
+	int rv;
 
-	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
-                return -EINVAL;
+	rv = kstrtouint(page, 10, &tmp);
+	if (rv < 0)
+		return rv;
 
 	/* this will validate ranges for us. */
 	o2hb_dead_threshold_set((unsigned int) tmp);
diff -puN fs/ocfs2/cluster/nodemanager.c~parse_integer-convert-fs-ocfs2 fs/ocfs2/cluster/nodemanager.c
--- a/fs/ocfs2/cluster/nodemanager.c~parse_integer-convert-fs-ocfs2
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -195,13 +195,12 @@ static ssize_t o2nm_node_num_write(struc
 				   size_t count)
 {
 	struct o2nm_cluster *cluster = to_o2nm_cluster_from_node(node);
-	unsigned long tmp;
-	char *p = (char *)page;
-
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	unsigned int tmp;
+	int rv;
 
+	rv = parse_integer(page, 0, &tmp);
+	if (rv < 0)
+		return rv;
 	if (tmp >= O2NM_MAX_NODES)
 		return -ERANGE;
 
@@ -215,16 +214,15 @@ static ssize_t o2nm_node_num_write(struc
 
 	write_lock(&cluster->cl_nodes_lock);
 	if (cluster->cl_nodes[tmp])
-		p = NULL;
+		rv = -EEXIST;
 	else  {
 		cluster->cl_nodes[tmp] = node;
 		node->nd_num = tmp;
 		set_bit(tmp, cluster->cl_nodes_bitmap);
 	}
 	write_unlock(&cluster->cl_nodes_lock);
-	if (p == NULL)
-		return -EEXIST;
-
+	if (rv < 0)
+		return rv;
 	return count;
 }
 static ssize_t o2nm_node_ipv4_port_read(struct o2nm_node *node, char *page)
@@ -235,13 +233,12 @@ static ssize_t o2nm_node_ipv4_port_read(
 static ssize_t o2nm_node_ipv4_port_write(struct o2nm_node *node,
 					 const char *page, size_t count)
 {
-	unsigned long tmp;
-	char *p = (char *)page;
-
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	u16 tmp;
+	int rv;
 
+	rv = kstrtou16(page, 0, &tmp);
+	if (rv < 0)
+		return rv;
 	if (tmp == 0)
 		return -EINVAL;
 	if (tmp >= (u16)-1)
@@ -305,13 +302,11 @@ static ssize_t o2nm_node_local_write(str
 {
 	struct o2nm_cluster *cluster = to_o2nm_cluster_from_node(node);
 	unsigned long tmp;
-	char *p = (char *)page;
 	ssize_t ret;
 
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
-
+	ret = kstrtoul(page, 0, &tmp);
+	if (ret < 0)
+		return ret;
 	tmp = !!tmp; /* boolean of whether this node wants to be local */
 
 	/* setting local turns on networking rx for now so we require having
@@ -484,16 +479,15 @@ struct o2nm_cluster_attribute {
 static ssize_t o2nm_cluster_attr_write(const char *page, ssize_t count,
                                        unsigned int *val)
 {
-	unsigned long tmp;
-	char *p = (char *)page;
-
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	unsigned int tmp;
+	int rv;
 
+	rv = kstrtouint(page, 0, &tmp);
+	if (rv < 0)
+		return rv;
 	if (tmp == 0)
 		return -EINVAL;
-	if (tmp >= (u32)-1)
+	if (tmp >= (unsigned int)-1)
 		return -ERANGE;
 
 	*val = tmp;
diff -puN fs/ocfs2/stack_user.c~parse_integer-convert-fs-ocfs2 fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~parse_integer-convert-fs-ocfs2
+++ a/fs/ocfs2/stack_user.c
@@ -368,9 +368,9 @@ static int ocfs2_control_get_this_node(v
 static int ocfs2_control_do_setnode_msg(struct file *file,
 					struct ocfs2_control_message_setn *msg)
 {
-	long nodenum;
-	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
+	int nodenum;
+	int rv;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
@@ -384,12 +384,12 @@ static int ocfs2_control_do_setnode_msg(
 		return -EINVAL;
 	msg->space = msg->newline = '\0';
 
-	nodenum = simple_strtol(msg->nodestr, &ptr, 16);
-	if (!ptr || *ptr)
+	rv = parse_integer(msg->nodestr, 16, &nodenum);
+	if (rv < 0)
+		return rv;
+	if (msg->nodestr[rv])
 		return -EINVAL;
-
-	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
-	    (nodenum > INT_MAX) || (nodenum < 0))
+	if (nodenum < 0)
 		return -ERANGE;
 	p->op_this_node = nodenum;
 
@@ -399,11 +399,11 @@ static int ocfs2_control_do_setnode_msg(
 static int ocfs2_control_do_setversion_msg(struct file *file,
 					   struct ocfs2_control_message_setv *msg)
  {
-	long major, minor;
-	char *ptr = NULL;
+	u8 major, minor;
 	struct ocfs2_control_private *p = file->private_data;
 	struct ocfs2_protocol_version *max =
 		&ocfs2_user_plugin.sp_max_proto;
+	int rv;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
@@ -418,11 +418,15 @@ static int ocfs2_control_do_setversion_m
 		return -EINVAL;
 	msg->space1 = msg->space2 = msg->newline = '\0';
 
-	major = simple_strtol(msg->major, &ptr, 16);
-	if (!ptr || *ptr)
-		return -EINVAL;
-	minor = simple_strtol(msg->minor, &ptr, 16);
-	if (!ptr || *ptr)
+	rv = parse_integer(msg->major, 16, &major);
+	if (rv < 0)
+		return rv;
+	if (msg->major[rv])
+		return -EINVAL;
+	rv = parse_integer(msg->minor, 16, &minor);
+	if (rv < 0)
+		return rv;
+	if (msg->minor[rv])
 		return -EINVAL;
 
 	/*
@@ -430,11 +434,7 @@ static int ocfs2_control_do_setversion_m
 	 * must be between 0 and 255, inclusive.  The version passed in
 	 * must be within the maximum version supported by the filesystem.
 	 */
-	if ((major == LONG_MIN) || (major == LONG_MAX) ||
-	    (major > (u8)-1) || (major < 1))
-		return -ERANGE;
-	if ((minor == LONG_MIN) || (minor == LONG_MAX) ||
-	    (minor > (u8)-1) || (minor < 0))
+	if (major < 1)
 		return -ERANGE;
 	if ((major != max->pv_major) ||
 	    (minor > max->pv_minor))
@@ -449,8 +449,8 @@ static int ocfs2_control_do_setversion_m
 static int ocfs2_control_do_down_msg(struct file *file,
 				     struct ocfs2_control_message_down *msg)
 {
-	long nodenum;
-	char *p = NULL;
+	int nodenum;
+	int rv;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_VALID)
@@ -465,12 +465,12 @@ static int ocfs2_control_do_down_msg(str
 		return -EINVAL;
 	msg->space1 = msg->space2 = msg->newline = '\0';
 
-	nodenum = simple_strtol(msg->nodestr, &p, 16);
-	if (!p || *p)
+	rv = parse_integer(msg->nodestr, 16, &nodenum);
+	if (rv < 0)
+		return rv;
+	if (msg->nodestr[rv])
 		return -EINVAL;
