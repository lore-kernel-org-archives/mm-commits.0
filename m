From: akpm@linux-foundation.org
Subject: + mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch
 added to -mm tree
Date: Mon, 11 Nov 2013 15:34:29 -0800
Message-ID: <52816985.v5mFIEqWG18pnZwS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab3KKXea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:34:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shmulik.ladkani@gmail.com, kzak@redhat.com, ezequiel.garcia@free-electrons.com, dwmw2@infradead.org, dedekind1@gmail.com, computersforpeace@gmail.com, axboe@kernel.dk, albert.wanglin@hisilicon.com, caizhiyong@huawei.com

Subject: + mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch added to -mm tree
To: caizhiyong@huawei.com,albert.wanglin@hisilicon.com,axboe@kernel.dk,computersforpeace@gmail.com,dedekind1@gmail.com,dwmw2@infradead.org,ezequiel.garcia@free-electrons.com,kzak@redhat.com,shmulik.ladkani@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:34:29 -0800


The patch titled
     Subject: mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix
has been added to the -mm tree.  Its filename is
     mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cai Zhiyong <caizhiyong@huawei.com>
Subject: mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix

 -Fix compile warning with value and function undeclared.
  this reported by <fengguang.wu@intel.com> and
  Randy Dunlap <rdunlap@infradead.org>

 -perfect cmdline format checking, make the error information clear
  for understand, make this lib fully equivalent to the old parser
  in drivers/mtd/cmdlinepart.c

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Brian Norris <computersforpeace@gmail.com>
Cc: "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cmdline-parser.c         |   86 +++++--
 drivers/mtd/Kconfig            |    1 
 drivers/mtd/cmdlinepart.c      |  345 +++++++++++++++++++++++++++----
 include/linux/cmdline-parser.h |    1 
 4 files changed, 371 insertions(+), 62 deletions(-)

diff -puN block/cmdline-parser.c~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix block/cmdline-parser.c
--- a/block/cmdline-parser.c~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix
+++ a/block/cmdline-parser.c
@@ -6,10 +6,15 @@
  */
 #include <linux/export.h>
 #include <linux/cmdline-parser.h>
+#include <linux/slab.h>
+
+#define PARSER                       "cmdline-parser: "
 
 static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
 {
 	int ret = 0;
+	int lastpart = 0;
+	char *partorg = partdef;
 	struct cmdline_subpart *new_subpart;
 
 	*subpart = NULL;
@@ -21,10 +26,12 @@ static int parse_subpart(struct cmdline_
 	if (*partdef == '-') {
 		new_subpart->size = (sector_t)(~0ULL);
 		partdef++;
+		lastpart = 1;
 	} else {
 		new_subpart->size = (sector_t)memparse(partdef, &partdef);
 		if (new_subpart->size < (sector_t)PAGE_SIZE) {
-			pr_warn("cmdline partition size is invalid.");
+			pr_warn(PARSER "partition '%s' size '0x%llx' too small.",
+				partorg, new_subpart->size);
 			ret = -EINVAL;
 			goto fail;
 		}
@@ -42,13 +49,19 @@ static int parse_subpart(struct cmdline_
 		char *next = strchr(++partdef, ')');
 
 		if (!next) {
-			pr_warn("cmdline partition format is invalid.");
+			pr_warn(PARSER "partition '%s' has no closing ')' "
+				"found in partition name.", partorg);
 			ret = -EINVAL;
 			goto fail;
 		}
 
-		length = min_t(int, next - partdef,
-			       sizeof(new_subpart->name) - 1);
+		length = (int)(next - partdef);
+		if (length > sizeof(new_subpart->name) - 1) {
+			pr_warn(PARSER "partition '%s' partition name too long,"
+				" truncating.", partorg);
+			length = sizeof(new_subpart->name) - 1;
+		}
+
 		strncpy(new_subpart->name, partdef, length);
 		new_subpart->name[length] = '\0';
 
@@ -68,8 +81,15 @@ static int parse_subpart(struct cmdline_
 		partdef += 2;
 	}
 
+	if (*partdef) {
+		pr_warn(PARSER "partition '%s' has bad character '%c' after"
+			" partition.", partorg, *partdef);
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	*subpart = new_subpart;
-	return 0;
+	return lastpart;
 fail:
 	kfree(new_subpart);
 	return ret;
@@ -86,14 +106,13 @@ static void free_subpart(struct cmdline_
 	}
 }
 
-static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
+static int parse_parts(struct cmdline_parts **parts, char *bdevdef)
 {
 	int ret = -EINVAL;
 	char *next;
 	int length;
 	struct cmdline_subpart **next_subpart;
 	struct cmdline_parts *newparts;
-	char buf[BDEVNAME_SIZE + 32 + 4];
 
 	*parts = NULL;
 
@@ -102,14 +121,21 @@ static int parse_parts(struct cmdline_pa
 		return -ENOMEM;
 
 	next = strchr(bdevdef, ':');
-	if (!next) {
-		pr_warn("cmdline partition has no block device.");
+	if (!next || next == bdevdef) {
+		pr_warn(PARSER "partition '%s' has no block device.", bdevdef);
 		goto fail;
 	}
 
-	length = min_t(int, next - bdevdef, sizeof(newparts->name) - 1);
+	length = (int)(next - bdevdef);
+	if (length > sizeof(newparts->name) - 1) {
+		pr_warn(PARSER "partition '%s' device name too long, "
+			"truncating.", bdevdef);
+		length = sizeof(newparts->name) - 1;
+	}
+
 	strncpy(newparts->name, bdevdef, length);
 	newparts->name[length] = '\0';
+
 	newparts->nr_subparts = 0;
 
 	next_subpart = &newparts->subpart;
@@ -117,23 +143,26 @@ static int parse_parts(struct cmdline_pa
 	while (next && *(++next)) {
 		bdevdef = next;
 		next = strchr(bdevdef, ',');
+		if (next)
+			*next = '\0';
 
-		length = (!next) ? (sizeof(buf) - 1) :
-			min_t(int, next - bdevdef, sizeof(buf) - 1);
-
-		strncpy(buf, bdevdef, length);
-		buf[length] = '\0';
-
-		ret = parse_subpart(next_subpart, buf);
-		if (ret)
+		ret = parse_subpart(next_subpart, bdevdef);
+		if (ret < 0) {
 			goto fail;
+		} else if (ret > 0 && next) {
+			pr_warn(PARSER "no partitions allowed after a "
+				"fill-up partition.");
+			ret = -EINVAL;
+			goto fail;
+		}
 
 		newparts->nr_subparts++;
 		next_subpart = &(*next_subpart)->next_subpart;
 	}
 
 	if (!newparts->subpart) {
-		pr_warn("cmdline partition has no valid partition.");
+		pr_warn(PARSER "block device '%s' has no valid"
+			" partition.", newparts->name);
 		ret = -EINVAL;
 		goto fail;
 	}
@@ -192,7 +221,7 @@ int cmdline_parts_parse(struct cmdline_p
 	}
 
 	if (!*parts) {
-		pr_warn("cmdline partition has no valid partition.");
+		pr_warn(PARSER "no found valid partition.");
 		ret = -EINVAL;
 		goto fail;
 	}
@@ -237,11 +266,24 @@ int cmdline_parts_set(struct cmdline_par
 		else
 			from = subpart->from;
 
-		if (from >= disk_size)
+		if (subpart->name[0] == '\0')
+			snprintf(subpart->name, sizeof(subpart->name),
+				 "partition%03d", slot);
+
+		if (from >= disk_size) {
+			pr_warn(PARSER "partition '%s' offset exceeds device"
+				" '%s' size '0x%llx', ignoring.",
+				subpart->name, parts->name, disk_size);
 			break;
+		}
 
-		if (subpart->size > (disk_size - from))
+		if (subpart->size > (disk_size - from)) {
+			if (subpart->size != (sector_t)(~0ULL))
+				pr_warn(PARSER "partition '%s' size exceeds "
+					"device '%s' size '0x%llx', truncating.",
+					subpart->name, parts->name, disk_size);
 			subpart->size = disk_size - from;
+		}
 
 		from += subpart->size;
 
diff -puN drivers/mtd/Kconfig~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix drivers/mtd/Kconfig
--- a/drivers/mtd/Kconfig~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix
+++ a/drivers/mtd/Kconfig
@@ -75,7 +75,6 @@ endif # MTD_REDBOOT_PARTS
 
 config MTD_CMDLINE_PARTS
 	tristate "Command line partition table parsing"
-	select BLK_CMDLINE_PARSER
 	depends on MTD
 	---help---
 	  Allow generic configuration of the MTD partition tables via the kernel
diff -puN drivers/mtd/cmdlinepart.c~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix drivers/mtd/cmdlinepart.c
--- a/drivers/mtd/cmdlinepart.c~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix
+++ a/drivers/mtd/cmdlinepart.c
@@ -47,79 +47,344 @@
  * 1 NOR Flash with 2 partitions, 1 NAND with one
  * edb7312-nor:256k(ARMboot)ro,-(root);edb7312-nand:-(home)
  */
- /*
-  * Copyright © 2013 Cai Zhiyong <caizhiyong@huawei.com>
-  * Rewrite the cmdline parser code, adjust it to a library-style code.
-  * this module only use the cmdline parser lib.
-  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <linux/cmdline-parser.h>
 
+/* error message prefix */
+#define ERRP "mtd: "
+
+/* debug macro */
+#if 0
+#define dbg(x) do { printk("DEBUG-CMDLINE-PART: "); printk x; } while(0)
+#else
+#define dbg(x)
+#endif
+
+
+/* special size referring to all the remaining space in a partition */
+#define SIZE_REMAINING ULLONG_MAX
+#define OFFSET_CONTINUOUS ULLONG_MAX
+
+struct cmdline_mtd_partition {
+	struct cmdline_mtd_partition *next;
+	char *mtd_id;
+	int num_parts;
+	struct mtd_partition *parts;
+};
+
+/* mtdpart_setup() parses into here */
+static struct cmdline_mtd_partition *partitions;
+
+/* the command line passed to mtdpart_setup() */
 static char *mtdparts;
-static struct cmdline_parts *mtd_cmdline_parts;
+static char *cmdline;
+static int cmdline_parsed;
 
-static int add_part(int slot, struct cmdline_subpart *subpart, void *param)
+/*
+ * Parse one partition definition for an MTD. Since there can be many
+ * comma separated partition definitions, this function calls itself
+ * recursively until no more partition definitions are found. Nice side
+ * effect: the memory to keep the mtd_partition structs and the names
+ * is allocated upon the last definition being found. At that point the
+ * syntax has been verified ok.
+ */
+static struct mtd_partition * newpart(char *s,
+				      char **retptr,
+				      int *num_parts,
+				      int this_part,
+				      unsigned char **extra_mem_ptr,
+				      int extra_mem_size)
 {
-	struct mtd_partition *mtdpart = &((struct mtd_partition *)param)[slot];
+	struct mtd_partition *parts;
+	unsigned long long size, offset = OFFSET_CONTINUOUS;
+	char *name;
+	int name_len;
+	unsigned char *extra_mem;
+	char delim;
+	unsigned int mask_flags;
+
+	/* fetch the partition size */
+	if (*s == '-') {
+		/* assign all remaining space to this partition */
+		size = SIZE_REMAINING;
+		s++;
+	} else {
+		size = memparse(s, &s);
+		if (size < PAGE_SIZE) {
+			printk(KERN_ERR ERRP "partition size too small (%llx)\n",
+			       size);
+			return ERR_PTR(-EINVAL);
+		}
+	}
 
-	mtdpart->offset = subpart->from;
-	mtdpart->size = subpart->size;
-	mtdpart->name = subpart->name;
-	mtdpart->mask_flags = 0;
+	/* fetch partition name and flags */
+	mask_flags = 0; /* this is going to be a regular partition */
+	delim = 0;
+
+	/* check for offset */
+	if (*s == '@') {
+		s++;
+		offset = memparse(s, &s);
+	}
 
-	if (subpart->flags & PF_RDONLY)
-		mtdpart->mask_flags |= MTD_WRITEABLE;
+	/* now look for name */
+	if (*s == '(')
+		delim = ')';
+
+	if (delim) {
+		char *p;
+
+		name = ++s;
+		p = strchr(name, delim);
+		if (!p) {
+			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
+			return ERR_PTR(-EINVAL);
+		}
+		name_len = p - name;
+		s = p + 1;
+	} else {
+		name = NULL;
+		name_len = 13; /* Partition_000 */
+	}
 
-	if (subpart->flags & PF_POWERUP_LOCK)
-		mtdpart->mask_flags |= MTD_POWERUP_LOCK;
+	/* record name length for memory allocation later */
+	extra_mem_size += name_len + 1;
 
-	return 0;
+	/* test for options */
+	if (strncmp(s, "ro", 2) == 0) {
+		mask_flags |= MTD_WRITEABLE;
+		s += 2;
+	}
+
+	/* if lk is found do NOT unlock the MTD partition*/
+	if (strncmp(s, "lk", 2) == 0) {
+		mask_flags |= MTD_POWERUP_LOCK;
+		s += 2;
+	}
+
+	/* test if more partitions are following */
+	if (*s == ',') {
+		if (size == SIZE_REMAINING) {
+			printk(KERN_ERR ERRP "no partitions allowed after a fill-up partition\n");
+			return ERR_PTR(-EINVAL);
+		}
+		/* more partitions follow, parse them */
+		parts = newpart(s + 1, &s, num_parts, this_part + 1,
+				&extra_mem, extra_mem_size);
+		if (IS_ERR(parts))
+			return parts;
+	} else {
+		/* this is the last partition: allocate space for all */
+		int alloc_size;
+
+		*num_parts = this_part + 1;
+		alloc_size = *num_parts * sizeof(struct mtd_partition) +
+			     extra_mem_size;
+
+		parts = kzalloc(alloc_size, GFP_KERNEL);
+		if (!parts)
+			return ERR_PTR(-ENOMEM);
+		extra_mem = (unsigned char *)(parts + *num_parts);
+	}
+
+	/* enter this partition (offset will be calculated later if it is zero at this point) */
+	parts[this_part].size = size;
+	parts[this_part].offset = offset;
+	parts[this_part].mask_flags = mask_flags;
+	if (name)
+		strlcpy(extra_mem, name, name_len + 1);
+	else
+		sprintf(extra_mem, "Partition_%03d", this_part);
+	parts[this_part].name = extra_mem;
+	extra_mem += name_len + 1;
+
+	dbg(("partition %d: name <%s>, offset %llx, size %llx, mask flags %x\n",
+	     this_part, parts[this_part].name, parts[this_part].offset,
+	     parts[this_part].size, parts[this_part].mask_flags));
+
+	/* return (updated) pointer to extra_mem memory */
+	if (extra_mem_ptr)
+		*extra_mem_ptr = extra_mem;
+
+	/* return (updated) pointer command line string */
+	*retptr = s;
+
+	/* return partition table */
+	return parts;
 }
 
-static int __init mtdpart_setup(char *s)
+/*
+ * Parse the command line.
+ */
+static int mtdpart_setup_real(char *s)
 {
-	mtdparts = s;
-	return 1;
+	cmdline_parsed = 1;
+
+	for( ; s != NULL; )
+	{
+		struct cmdline_mtd_partition *this_mtd;
+		struct mtd_partition *parts;
+		int mtd_id_len, num_parts;
+		char *p, *mtd_id;
+
+		mtd_id = s;
+
+		/* fetch <mtd-id> */
+		p = strchr(s, ':');
+		if (!p) {
+			printk(KERN_ERR ERRP "no mtd-id\n");
+			return -EINVAL;
+		}
+		mtd_id_len = p - mtd_id;
+
+		dbg(("parsing <%s>\n", p+1));
+
+		/*
+		 * parse one mtd. have it reserve memory for the
+		 * struct cmdline_mtd_partition and the mtd-id string.
+		 */
+		parts = newpart(p + 1,		/* cmdline */
+				&s,		/* out: updated cmdline ptr */
+				&num_parts,	/* out: number of parts */
+				0,		/* first partition */
+				(unsigned char**)&this_mtd, /* out: extra mem */
+				mtd_id_len + 1 + sizeof(*this_mtd) +
+				sizeof(void*)-1 /*alignment*/);
+		if (IS_ERR(parts)) {
+			/*
+			 * An error occurred. We're either:
+			 * a) out of memory, or
+			 * b) in the middle of the partition spec
+			 * Either way, this mtd is hosed and we're
+			 * unlikely to succeed in parsing any more
+			 */
+			 return PTR_ERR(parts);
+		 }
+
+		/* align this_mtd */
+		this_mtd = (struct cmdline_mtd_partition *)
+				ALIGN((unsigned long)this_mtd, sizeof(void *));
+		/* enter results */
+		this_mtd->parts = parts;
+		this_mtd->num_parts = num_parts;
+		this_mtd->mtd_id = (char*)(this_mtd + 1);
+		strlcpy(this_mtd->mtd_id, mtd_id, mtd_id_len + 1);
+
+		/* link into chain */
+		this_mtd->next = partitions;
+		partitions = this_mtd;
+
+		dbg(("mtdid=<%s> num_parts=<%d>\n",
+		     this_mtd->mtd_id, this_mtd->num_parts));
+
+
+		/* EOS - we're done */
+		if (*s == 0)
+			break;
+
+		/* does another spec follow? */
+		if (*s != ';') {
+			printk(KERN_ERR ERRP "bad character after partition (%c)\n", *s);
+			return -EINVAL;
+		}
+		s++;
+	}
+
+	return 0;
 }
-__setup("mtdparts=", mtdpart_setup);
 
+/*
+ * Main function to be called from the MTD mapping driver/device to
+ * obtain the partitioning information. At this point the command line
+ * arguments will actually be parsed and turned to struct mtd_partition
+ * information. It returns partitions for the requested mtd device, or
+ * the first one in the chain if a NULL mtd_id is passed in.
+ */
 static int parse_cmdline_partitions(struct mtd_info *master,
 				    struct mtd_partition **pparts,
 				    struct mtd_part_parser_data *data)
 {
-	struct cmdline_parts *parts;
-
-	if (mtdparts) {
-		if (mtd_cmdline_parts)
-			cmdline_parts_free(&mtd_cmdline_parts);
+	unsigned long long offset;
+	int i, err;
+	struct cmdline_mtd_partition *part;
+	const char *mtd_id = master->name;
+
+	/* parse command line */
+	if (!cmdline_parsed) {
+		err = mtdpart_setup_real(cmdline);
+		if (err)
+			return err;
+	}
 
-		if (cmdline_parts_parse(&mtd_cmdline_parts, mtdparts)) {
-			mtdparts = NULL;
-			return -EINVAL;
-		}
-		mtdparts = NULL;
+	/*
+	 * Search for the partition definition matching master->name.
+	 * If master->name is not set, stop at first partition definition.
+	 */
+	for (part = partitions; part; part = part->next) {
+		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
+			break;
 	}
 
-	if (!mtd_cmdline_parts)
+	if (!part)
 		return 0;
 
-	parts = cmdline_parts_find(mtd_cmdline_parts, master->name);
-	if (!parts)
-		return 0;
+	for (i = 0, offset = 0; i < part->num_parts; i++) {
+		if (part->parts[i].offset == OFFSET_CONTINUOUS)
+			part->parts[i].offset = offset;
+		else
+			offset = part->parts[i].offset;
+
+		if (part->parts[i].size == SIZE_REMAINING)
+			part->parts[i].size = master->size - offset;
+
+		if (offset + part->parts[i].size > master->size) {
+			printk(KERN_WARNING ERRP
+			       "%s: partitioning exceeds flash size, truncating\n",
+			       part->mtd_id);
+			part->parts[i].size = master->size - offset;
+		}
+		offset += part->parts[i].size;
+
+		if (part->parts[i].size == 0) {
+			printk(KERN_WARNING ERRP
+			       "%s: skipping zero sized partition\n",
+			       part->mtd_id);
+			part->num_parts--;
+			memmove(&part->parts[i], &part->parts[i + 1],
+				sizeof(*part->parts) * (part->num_parts - i));
+			i--;
+		}
+	}
 
-	*pparts = kzalloc(sizeof(**pparts) * parts->nr_subparts, GFP_KERNEL);
+	*pparts = kmemdup(part->parts, sizeof(*part->parts) * part->num_parts,
+			  GFP_KERNEL);
 	if (!*pparts)
 		return -ENOMEM;
 
-	return cmdline_parts_set(parts, master->size, 0, add_part,
-				 (void *)*pparts);
+	return part->num_parts;
 }
 
+
+/*
+ * This is the handler for our kernel parameter, called from
+ * main.c::checksetup(). Note that we can not yet kmalloc() anything,
+ * so we only save the commandline for later processing.
+ *
+ * This function needs to be visible for bootloaders.
+ */
+static int __init mtdpart_setup(char *s)
+{
+	cmdline = s;
+	return 1;
+}
+
+__setup("mtdparts=", mtdpart_setup);
+
 static struct mtd_part_parser cmdline_parser = {
 	.owner = THIS_MODULE,
 	.parse_fn = parse_cmdline_partitions,
@@ -128,6 +393,8 @@ static struct mtd_part_parser cmdline_pa
 
 static int __init cmdline_parser_init(void)
 {
+	if (mtdparts)
+		mtdpart_setup(mtdparts);
 	return register_mtd_parser(&cmdline_parser);
 }
 
diff -puN include/linux/cmdline-parser.h~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix include/linux/cmdline-parser.h
--- a/include/linux/cmdline-parser.h~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix
+++ a/include/linux/cmdline-parser.h
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/blkdev.h>
+#include <linux/fs.h>
 
 /* partition flags */
 #define PF_RDONLY                   0x01 /* Device is read only */
_

Patches currently in -mm which might be from caizhiyong@huawei.com are

block-remove-unrelated-header-files-and-export-symbol.patch
block-remove-unrelated-header-files-and-export-symbol-fix.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch

