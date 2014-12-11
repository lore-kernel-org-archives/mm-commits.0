From: akpm@linux-foundation.org
Subject: [merged] binfmt_misc-clean-up-code-style-a-bit.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:50 -0800
Message-ID: <5489eb0e.+fbTzqtcBbUAmR/h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbaLKTFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, joe@perches.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: clean up code style a bit
has been removed from the -mm tree.  Its filename was
     binfmt_misc-clean-up-code-style-a-bit.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Mike Frysinger <vapier@gentoo.org>
Subject: binfmt_misc: clean up code style a bit

Clean up various coding style issues that checkpatch complains about.
No functional changes here.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |  293 ++++++++++++++++++++++-----------------------
 1 file changed, 145 insertions(+), 148 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-clean-up-code-style-a-bit fs/bin=
fmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-clean-up-code-style-a-bit
+++ a/fs/binfmt_misc.c
@@ -1,19 +1,10 @@
 /*
- *  binfmt_misc.c
+ * binfmt_misc.c
  *
- *  Copyright (C) 1997 Richard G=C3=BCnther
+ * Copyright (C) 1997 Richard G=C3=BCnther
  *
- *  binfmt_misc detects binaries via a magic or filename extension and=
 invokes
- *  a specified wrapper. This should obsolete binfmt_java, binfmt_em86=
 and
- *  binfmt_mz.
- *
- *  1997-04-25 first version
- *  [...]
- *  1997-05-19 cleanup
- *  1997-06-26 hpa: pass the real filename rather than argv[0]
- *  1997-06-30 minor cleanup
- *  1997-08-09 removed extension stripping, locking cleanup
- *  2001-02-28 AV: rewritten into something that resembles C. Original=
 didn't.
+ * binfmt_misc detects binaries via a magic or filename extension and =
invokes
+ * a specified wrapper. See Documentation/binfmt_misc.txt for more det=
ails.
  */
=20
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -48,9 +39,9 @@ static LIST_HEAD(entries);
 static int enabled =3D 1;
=20
 enum {Enabled, Magic};
-#define MISC_FMT_PRESERVE_ARGV0 (1<<31)
-#define MISC_FMT_OPEN_BINARY (1<<30)
-#define MISC_FMT_CREDENTIALS (1<<29)
+#define MISC_FMT_PRESERVE_ARGV0 (1 << 31)
+#define MISC_FMT_OPEN_BINARY (1 << 30)
+#define MISC_FMT_CREDENTIALS (1 << 29)
=20
 typedef struct {
 	struct list_head list;
@@ -134,7 +125,7 @@ static Node *check_file(struct linux_bin
 static int load_misc_binary(struct linux_binprm *bprm)
 {
 	Node *fmt;
-	struct file * interp_file =3D NULL;
+	struct file *interp_file =3D NULL;
 	char iname[BINPRM_BUF_SIZE];
 	const char *iname_addr =3D iname;
 	int retval;
@@ -142,7 +133,7 @@ static int load_misc_binary(struct linux
=20
 	retval =3D -ENOEXEC;
 	if (!enabled)
-		goto _ret;
+		goto ret;
=20
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
@@ -151,25 +142,26 @@ static int load_misc_binary(struct linux
 		strlcpy(iname, fmt->interpreter, BINPRM_BUF_SIZE);
 	read_unlock(&entries_lock);
 	if (!fmt)
-		goto _ret;
+		goto ret;
=20
 	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
 		retval =3D remove_arg_zero(bprm);
 		if (retval)
-			goto _ret;
+			goto ret;
 	}
=20
 	if (fmt->flags & MISC_FMT_OPEN_BINARY) {
=20
 		/* if the binary should be opened on behalf of the
 		 * interpreter than keep it open and assign descriptor
-		 * to it */
+		 * to it
+		 */
 		fd_binary =3D get_unused_fd_flags(0);
- 		if (fd_binary < 0) {
- 			retval =3D fd_binary;
- 			goto _ret;
- 		}
- 		fd_install(fd_binary, bprm->file);
+		if (fd_binary < 0) {
+			retval =3D fd_binary;
+			goto ret;
+		}
+		fd_install(fd_binary, bprm->file);
=20
 		/* if the binary is not readable than enforce mm->dumpable=3D0
 		   regardless of the interpreter's permissions */
@@ -182,32 +174,32 @@ static int load_misc_binary(struct linux
 		bprm->interp_flags |=3D BINPRM_FLAGS_EXECFD;
 		bprm->interp_data =3D fd_binary;
=20
- 	} else {
- 		allow_write_access(bprm->file);
- 		fput(bprm->file);
- 		bprm->file =3D NULL;
- 	}
+	} else {
+		allow_write_access(bprm->file);
+		fput(bprm->file);
+		bprm->file =3D NULL;
+	}
 	/* make argv[1] be the path to the binary */
-	retval =3D copy_strings_kernel (1, &bprm->interp, bprm);
+	retval =3D copy_strings_kernel(1, &bprm->interp, bprm);
 	if (retval < 0)
-		goto _error;
+		goto error;
 	bprm->argc++;
=20
 	/* add the interp as argv[0] */
-	retval =3D copy_strings_kernel (1, &iname_addr, bprm);
+	retval =3D copy_strings_kernel(1, &iname_addr, bprm);
 	if (retval < 0)
-		goto _error;
-	bprm->argc ++;
+		goto error;
+	bprm->argc++;
=20
 	/* Update interp in case binfmt_script needs it. */
 	retval =3D bprm_change_interp(iname, bprm);
 	if (retval < 0)
-		goto _error;
+		goto error;
=20
-	interp_file =3D open_exec (iname);
-	retval =3D PTR_ERR (interp_file);
-	if (IS_ERR (interp_file))
-		goto _error;
+	interp_file =3D open_exec(iname);
+	retval =3D PTR_ERR(interp_file);
+	if (IS_ERR(interp_file))
+		goto error;
=20
 	bprm->file =3D interp_file;
 	if (fmt->flags & MISC_FMT_CREDENTIALS) {
@@ -218,23 +210,23 @@ static int load_misc_binary(struct linux
 		memset(bprm->buf, 0, BINPRM_BUF_SIZE);
 		retval =3D kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
 	} else
-		retval =3D prepare_binprm (bprm);
+		retval =3D prepare_binprm(bprm);
=20
 	if (retval < 0)
-		goto _error;
+		goto error;
=20
 	retval =3D search_binary_handler(bprm);
 	if (retval < 0)
-		goto _error;
+		goto error;
=20
-_ret:
+ret:
 	return retval;
-_error:
+error:
 	if (fd_binary > 0)
 		sys_close(fd_binary);
 	bprm->interp_flags =3D 0;
 	bprm->interp_data =3D 0;
-	goto _ret;
+	goto ret;
 }
=20
 /* Command parsers */
@@ -261,39 +253,40 @@ static char *scanarg(char *s, char del)
 	return s;
 }
=20
-static char * check_special_flags (char * sfs, Node * e)
+static char *check_special_flags(char *sfs, Node *e)
 {
-	char * p =3D sfs;
+	char *p =3D sfs;
 	int cont =3D 1;
=20
 	/* special flags */
 	while (cont) {
 		switch (*p) {
-			case 'P':
-				pr_debug("register: flag: P (preserve argv0)\n");
-				p++;
-				e->flags |=3D MISC_FMT_PRESERVE_ARGV0;
-				break;
-			case 'O':
-				pr_debug("register: flag: O (open binary)\n");
-				p++;
-				e->flags |=3D MISC_FMT_OPEN_BINARY;
-				break;
-			case 'C':
-				pr_debug("register: flag: C (preserve creds)\n");
-				p++;
-				/* this flags also implies the
-				   open-binary flag */
-				e->flags |=3D (MISC_FMT_CREDENTIALS |
-						MISC_FMT_OPEN_BINARY);
-				break;
-			default:
-				cont =3D 0;
+		case 'P':
+			pr_debug("register: flag: P (preserve argv0)\n");
+			p++;
+			e->flags |=3D MISC_FMT_PRESERVE_ARGV0;
+			break;
+		case 'O':
+			pr_debug("register: flag: O (open binary)\n");
+			p++;
+			e->flags |=3D MISC_FMT_OPEN_BINARY;
+			break;
+		case 'C':
+			pr_debug("register: flag: C (preserve creds)\n");
+			p++;
+			/* this flags also implies the
+			   open-binary flag */
+			e->flags |=3D (MISC_FMT_CREDENTIALS |
+					MISC_FMT_OPEN_BINARY);
+			break;
+		default:
+			cont =3D 0;
 		}
 	}
=20
 	return p;
 }
+
 /*
  * This registers a new binary format, it recognises the syntax
  * ':name:type:offset:magic:mask:interpreter:flags'
@@ -323,26 +316,26 @@ static Node *create_entry(const char __u
=20
 	memset(e, 0, sizeof(Node));
 	if (copy_from_user(buf, buffer, count))
-		goto Efault;
+		goto efault;
=20
 	del =3D *p++;	/* delimeter */
=20
 	pr_debug("register: delim: %#x {%c}\n", del, del);
=20
 	/* Pad the buffer with the delim to simplify parsing below. */
-	memset(buf+count, del, 8);
+	memset(buf + count, del, 8);
=20
 	/* Parse the 'name' field. */
 	e->name =3D p;
 	p =3D strchr(p, del);
 	if (!p)
-		goto Einval;
+		goto einval;
 	*p++ =3D '\0';
 	if (!e->name[0] ||
 	    !strcmp(e->name, ".") ||
 	    !strcmp(e->name, "..") ||
 	    strchr(e->name, '/'))
-		goto Einval;
+		goto einval;
=20
 	pr_debug("register: name: {%s}\n", e->name);
=20
@@ -357,10 +350,10 @@ static Node *create_entry(const char __u
 		e->flags =3D (1 << Enabled) | (1 << Magic);
 		break;
 	default:
-		goto Einval;
+		goto einval;
 	}
 	if (*p++ !=3D del)
-		goto Einval;
+		goto einval;
=20
 	if (test_bit(Magic, &e->flags)) {
 		/* Handle the 'M' (magic) format. */
@@ -369,21 +362,21 @@ static Node *create_entry(const char __u
 		/* Parse the 'offset' field. */
 		s =3D strchr(p, del);
 		if (!s)
-			goto Einval;
+			goto einval;
 		*s++ =3D '\0';
 		e->offset =3D simple_strtoul(p, &p, 10);
 		if (*p++)
-			goto Einval;
+			goto einval;
 		pr_debug("register: offset: %#x\n", e->offset);
=20
 		/* Parse the 'magic' field. */
 		e->magic =3D p;
 		p =3D scanarg(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		p[-1] =3D '\0';
 		if (p =3D=3D e->magic)
-			goto Einval;
+			goto einval;
 		if (USE_DEBUG)
 			print_hex_dump_bytes(
 				KBUILD_MODNAME ": register: magic[raw]: ",
@@ -393,7 +386,7 @@ static Node *create_entry(const char __u
 		e->mask =3D p;
 		p =3D scanarg(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		p[-1] =3D '\0';
 		if (p =3D=3D e->mask) {
 			e->mask =3D NULL;
@@ -412,9 +405,9 @@ static Node *create_entry(const char __u
 		e->size =3D string_unescape_inplace(e->magic, UNESCAPE_HEX);
 		if (e->mask &&
 		    string_unescape_inplace(e->mask, UNESCAPE_HEX) !=3D e->size)
-			goto Einval;
+			goto einval;
 		if (e->size + e->offset > BINPRM_BUF_SIZE)
-			goto Einval;
+			goto einval;
 		pr_debug("register: magic/mask length: %i\n", e->size);
 		if (USE_DEBUG) {
 			print_hex_dump_bytes(
@@ -446,23 +439,23 @@ static Node *create_entry(const char __u
 		/* Skip the 'offset' field. */
 		p =3D strchr(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		*p++ =3D '\0';
=20
 		/* Parse the 'magic' field. */
 		e->magic =3D p;
 		p =3D strchr(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		*p++ =3D '\0';
 		if (!e->magic[0] || strchr(e->magic, '/'))
-			goto Einval;
+			goto einval;
 		pr_debug("register: extension: {%s}\n", e->magic);
=20
 		/* Skip the 'mask' field. */
 		p =3D strchr(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		*p++ =3D '\0';
 	}
=20
@@ -470,27 +463,28 @@ static Node *create_entry(const char __u
 	e->interpreter =3D p;
 	p =3D strchr(p, del);
 	if (!p)
-		goto Einval;
+		goto einval;
 	*p++ =3D '\0';
 	if (!e->interpreter[0])
-		goto Einval;
+		goto einval;
 	pr_debug("register: interpreter: {%s}\n", e->interpreter);
=20
 	/* Parse the 'flags' field. */
-	p =3D check_special_flags (p, e);
+	p =3D check_special_flags(p, e);
 	if (*p =3D=3D '\n')
 		p++;
 	if (p !=3D buf + count)
-		goto Einval;
+		goto einval;
+
 	return e;
=20
 out:
 	return ERR_PTR(err);
=20
-Efault:
+efault:
 	kfree(e);
 	return ERR_PTR(-EFAULT);
-Einval:
+einval:
 	kfree(e);
 	return ERR_PTR(-EINVAL);
 }
@@ -509,7 +503,7 @@ static int parse_command(const char __us
 		return -EFAULT;
 	if (!count)
 		return 0;
-	if (s[count-1] =3D=3D '\n')
+	if (s[count - 1] =3D=3D '\n')
 		count--;
 	if (count =3D=3D 1 && s[0] =3D=3D '0')
 		return 1;
@@ -526,7 +520,7 @@ static void entry_status(Node *e, char *
 {
 	char *dp;
 	char *status =3D "disabled";
-	const char * flags =3D "flags: ";
+	const char *flags =3D "flags: ";
=20
 	if (test_bit(Enabled, &e->flags))
 		status =3D "enabled";
@@ -540,19 +534,15 @@ static void entry_status(Node *e, char *
 	dp =3D page + strlen(page);
=20
 	/* print the special flags */
-	sprintf (dp, "%s", flags);
-	dp +=3D strlen (flags);
-	if (e->flags & MISC_FMT_PRESERVE_ARGV0) {
-		*dp ++ =3D 'P';
-	}
-	if (e->flags & MISC_FMT_OPEN_BINARY) {
-		*dp ++ =3D 'O';
-	}
-	if (e->flags & MISC_FMT_CREDENTIALS) {
-		*dp ++ =3D 'C';
-	}
-	*dp ++ =3D '\n';
-
+	sprintf(dp, "%s", flags);
+	dp +=3D strlen(flags);
+	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
+		*dp++ =3D 'P';
+	if (e->flags & MISC_FMT_OPEN_BINARY)
+		*dp++ =3D 'O';
+	if (e->flags & MISC_FMT_CREDENTIALS)
+		*dp++ =3D 'C';
+	*dp++ =3D '\n';
=20
 	if (!test_bit(Magic, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
@@ -580,7 +570,7 @@ static void entry_status(Node *e, char *
=20
 static struct inode *bm_get_inode(struct super_block *sb, int mode)
 {
-	struct inode * inode =3D new_inode(sb);
+	struct inode *inode =3D new_inode(sb);
=20
 	if (inode) {
 		inode->i_ino =3D get_next_ino();
@@ -620,13 +610,14 @@ static void kill_node(Node *e)
 /* /<entry> */
=20
 static ssize_t
-bm_entry_read(struct file * file, char __user * buf, size_t nbytes, lo=
ff_t *ppos)
+bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff=
_t *ppos)
 {
 	Node *e =3D file_inode(file)->i_private;
 	ssize_t res;
 	char *page;
=20
-	if (!(page =3D (char*) __get_free_page(GFP_KERNEL)))
+	page =3D (char *) __get_free_page(GFP_KERNEL);
+	if (!page)
 		return -ENOMEM;
=20
 	entry_status(e, page);
@@ -645,26 +636,28 @@ static ssize_t bm_entry_write(struct fil
 	int res =3D parse_command(buffer, count);
=20
 	switch (res) {
-		case 1:
-			/* Disable this handler. */
-			clear_bit(Enabled, &e->flags);
-			break;
-		case 2:
-			/* Enable this handler. */
-			set_bit(Enabled, &e->flags);
-			break;
-		case 3:
-			/* Delete this handler. */
-			root =3D dget(file->f_path.dentry->d_sb->s_root);
-			mutex_lock(&root->d_inode->i_mutex);
+	case 1:
+		/* Disable this handler. */
+		clear_bit(Enabled, &e->flags);
+		break;
+	case 2:
+		/* Enable this handler. */
+		set_bit(Enabled, &e->flags);
+		break;
+	case 3:
+		/* Delete this handler. */
+		root =3D dget(file->f_path.dentry->d_sb->s_root);
+		mutex_lock(&root->d_inode->i_mutex);
=20
-			kill_node(e);
+		kill_node(e);
=20
-			mutex_unlock(&root->d_inode->i_mutex);
-			dput(root);
-			break;
-		default: return res;
+		mutex_unlock(&root->d_inode->i_mutex);
+		dput(root);
+		break;
+	default:
+		return res;
 	}
+
 	return count;
 }
=20
@@ -752,34 +745,36 @@ bm_status_read(struct file *file, char _
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
=20
-static ssize_t bm_status_write(struct file * file, const char __user *=
 buffer,
+static ssize_t bm_status_write(struct file *file, const char __user *b=
uffer,
 		size_t count, loff_t *ppos)
 {
 	int res =3D parse_command(buffer, count);
 	struct dentry *root;
=20
 	switch (res) {
-		case 1:
-			/* Disable all handlers. */
-			enabled =3D 0;
-			break;
-		case 2:
-			/* Enable all handlers. */
-			enabled =3D 1;
-			break;
-		case 3:
-			/* Delete all handlers. */
-			root =3D dget(file->f_path.dentry->d_sb->s_root);
-			mutex_lock(&root->d_inode->i_mutex);
+	case 1:
+		/* Disable all handlers. */
+		enabled =3D 0;
+		break;
+	case 2:
+		/* Enable all handlers. */
+		enabled =3D 1;
+		break;
+	case 3:
+		/* Delete all handlers. */
+		root =3D dget(file->f_path.dentry->d_sb->s_root);
+		mutex_lock(&root->d_inode->i_mutex);
=20
-			while (!list_empty(&entries))
-				kill_node(list_entry(entries.next, Node, list));
+		while (!list_empty(&entries))
+			kill_node(list_entry(entries.next, Node, list));
=20
-			mutex_unlock(&root->d_inode->i_mutex);
-			dput(root);
-			break;
-		default: return res;
+		mutex_unlock(&root->d_inode->i_mutex);
+		dput(root);
+		break;
+	default:
+		return res;
 	}
+
 	return count;
 }
=20
@@ -796,14 +791,16 @@ static const struct super_operations s_o
 	.evict_inode	=3D bm_evict_inode,
 };
=20
-static int bm_fill_super(struct super_block * sb, void * data, int sil=
ent)
+static int bm_fill_super(struct super_block *sb, void *data, int silen=
t)
 {
+	int err;
 	static struct tree_descr bm_files[] =3D {
 		[2] =3D {"status", &bm_status_operations, S_IWUSR|S_IRUGO},
 		[3] =3D {"register", &bm_register_operations, S_IWUSR},
 		/* last one */ {""}
 	};
-	int err =3D simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
+
+	err =3D simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)
 		sb->s_op =3D &s_ops;
 	return err;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
