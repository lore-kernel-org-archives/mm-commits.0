From: akpm@linux-foundation.org
Subject: + fs-ufs-convert-printk-to-pr_foo.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:31:56 -0700
Message-ID: <53a4b65c.YlIT+daFaKYnVzn1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaFTWb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:31:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be


The patch titled
     Subject: fs/ufs: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     fs-ufs-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-convert-printk-to-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs: convert printk to pr_foo()

Use current logging functions.

- no level printk under CONFIG_UFS_DEBUG converted to pr_debug

- no level printk elsewhere converted to pr_err

- add DDEBUG flag in Makefile

- coalesce formats

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/Makefile |    1 
 fs/ufs/super.c  |  263 ++++++++++++++++++++++------------------------
 2 files changed, 131 insertions(+), 133 deletions(-)

diff -puN fs/ufs/Makefile~fs-ufs-convert-printk-to-pr_foo fs/ufs/Makefile
--- a/fs/ufs/Makefile~fs-ufs-convert-printk-to-pr_foo
+++ a/fs/ufs/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_UFS_FS) += ufs.o
 
 ufs-objs := balloc.o cylinder.o dir.o file.o ialloc.o inode.o \
 	    namei.o super.o symlink.o truncate.o util.o
+ccflags-$(CONFIG_UFS_DEBUG)    += -DDEBUG
diff -puN fs/ufs/super.c~fs-ufs-convert-printk-to-pr_foo fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-convert-printk-to-pr_foo
+++ a/fs/ufs/super.c
@@ -172,73 +172,73 @@ static void ufs_print_super_stuff(struct
 {
 	u32 magic = fs32_to_cpu(sb, usb3->fs_magic);
 
-	printk("ufs_print_super_stuff\n");
-	printk("  magic:     0x%x\n", magic);
+	pr_debug("ufs_print_super_stuff\n");
+	pr_debug("  magic:     0x%x\n", magic);
 	if (fs32_to_cpu(sb, usb3->fs_magic) == UFS2_MAGIC) {
-		printk("  fs_size:   %llu\n", (unsigned long long)
-		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.fs_size));
-		printk("  fs_dsize:  %llu\n", (unsigned long long)
-		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.fs_dsize));
-		printk("  bsize:         %u\n",
-		       fs32_to_cpu(sb, usb1->fs_bsize));
-		printk("  fsize:         %u\n",
-		       fs32_to_cpu(sb, usb1->fs_fsize));
-		printk("  fs_volname:  %s\n", usb2->fs_un.fs_u2.fs_volname);
-		printk("  fs_sblockloc: %llu\n", (unsigned long long)
-		       fs64_to_cpu(sb, usb2->fs_un.fs_u2.fs_sblockloc));
-		printk("  cs_ndir(No of dirs):  %llu\n", (unsigned long long)
-		       fs64_to_cpu(sb, usb2->fs_un.fs_u2.cs_ndir));
-		printk("  cs_nbfree(No of free blocks):  %llu\n",
-		       (unsigned long long)
-		       fs64_to_cpu(sb, usb2->fs_un.fs_u2.cs_nbfree));
-		printk(KERN_INFO"  cs_nifree(Num of free inodes): %llu\n",
-		       (unsigned long long)
-		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nifree));
-		printk(KERN_INFO"  cs_nffree(Num of free frags): %llu\n",
-		       (unsigned long long)
-		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
-		printk(KERN_INFO"  fs_maxsymlinklen: %u\n",
-		       fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen));
+		pr_debug("  fs_size:   %llu\n", (unsigned long long)
+			 fs64_to_cpu(sb, usb3->fs_un1.fs_u2.fs_size));
+		pr_debug("  fs_dsize:  %llu\n", (unsigned long long)
+			 fs64_to_cpu(sb, usb3->fs_un1.fs_u2.fs_dsize));
+		pr_debug("  bsize:         %u\n",
+			 fs32_to_cpu(sb, usb1->fs_bsize));
+		pr_debug("  fsize:         %u\n",
+			 fs32_to_cpu(sb, usb1->fs_fsize));
+		pr_debug("  fs_volname:  %s\n", usb2->fs_un.fs_u2.fs_volname);
+		pr_debug("  fs_sblockloc: %llu\n", (unsigned long long)
+			 fs64_to_cpu(sb, usb2->fs_un.fs_u2.fs_sblockloc));
+		pr_debug("  cs_ndir(No of dirs):  %llu\n", (unsigned long long)
+			 fs64_to_cpu(sb, usb2->fs_un.fs_u2.cs_ndir));
+		pr_debug("  cs_nbfree(No of free blocks):  %llu\n",
+			 (unsigned long long)
+			 fs64_to_cpu(sb, usb2->fs_un.fs_u2.cs_nbfree));
+		pr_info("  cs_nifree(Num of free inodes): %llu\n",
+			(unsigned long long)
+			fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nifree));
+		pr_info("  cs_nffree(Num of free frags): %llu\n",
+			(unsigned long long)
+			fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
+		pr_info("  fs_maxsymlinklen: %u\n",
+			fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen));
 	} else {
-		printk(" sblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_sblkno));
-		printk(" cblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_cblkno));
-		printk(" iblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_iblkno));
-		printk(" dblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_dblkno));
-		printk(" cgoffset:    %u\n",
-		       fs32_to_cpu(sb, usb1->fs_cgoffset));
-		printk(" ~cgmask:     0x%x\n",
-		       ~fs32_to_cpu(sb, usb1->fs_cgmask));
-		printk(" size:        %u\n", fs32_to_cpu(sb, usb1->fs_size));
-		printk(" dsize:       %u\n", fs32_to_cpu(sb, usb1->fs_dsize));
-		printk(" ncg:         %u\n", fs32_to_cpu(sb, usb1->fs_ncg));
-		printk(" bsize:       %u\n", fs32_to_cpu(sb, usb1->fs_bsize));
-		printk(" fsize:       %u\n", fs32_to_cpu(sb, usb1->fs_fsize));
-		printk(" frag:        %u\n", fs32_to_cpu(sb, usb1->fs_frag));
-		printk(" fragshift:   %u\n",
-		       fs32_to_cpu(sb, usb1->fs_fragshift));
-		printk(" ~fmask:      %u\n", ~fs32_to_cpu(sb, usb1->fs_fmask));
-		printk(" fshift:      %u\n", fs32_to_cpu(sb, usb1->fs_fshift));
-		printk(" sbsize:      %u\n", fs32_to_cpu(sb, usb1->fs_sbsize));
-		printk(" spc:         %u\n", fs32_to_cpu(sb, usb1->fs_spc));
-		printk(" cpg:         %u\n", fs32_to_cpu(sb, usb1->fs_cpg));
-		printk(" ipg:         %u\n", fs32_to_cpu(sb, usb1->fs_ipg));
-		printk(" fpg:         %u\n", fs32_to_cpu(sb, usb1->fs_fpg));
-		printk(" csaddr:      %u\n", fs32_to_cpu(sb, usb1->fs_csaddr));
-		printk(" cssize:      %u\n", fs32_to_cpu(sb, usb1->fs_cssize));
-		printk(" cgsize:      %u\n", fs32_to_cpu(sb, usb1->fs_cgsize));
-		printk(" fstodb:      %u\n",
-		       fs32_to_cpu(sb, usb1->fs_fsbtodb));
-		printk(" nrpos:       %u\n", fs32_to_cpu(sb, usb3->fs_nrpos));
-		printk(" ndir         %u\n",
-		       fs32_to_cpu(sb, usb1->fs_cstotal.cs_ndir));
-		printk(" nifree       %u\n",
-		       fs32_to_cpu(sb, usb1->fs_cstotal.cs_nifree));
-		printk(" nbfree       %u\n",
-		       fs32_to_cpu(sb, usb1->fs_cstotal.cs_nbfree));
-		printk(" nffree       %u\n",
-		       fs32_to_cpu(sb, usb1->fs_cstotal.cs_nffree));
+		pr_debug(" sblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_sblkno));
+		pr_debug(" cblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_cblkno));
+		pr_debug(" iblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_iblkno));
+		pr_debug(" dblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_dblkno));
+		pr_debug(" cgoffset:    %u\n",
+			 fs32_to_cpu(sb, usb1->fs_cgoffset));
+		pr_debug(" ~cgmask:     0x%x\n",
+			 ~fs32_to_cpu(sb, usb1->fs_cgmask));
+		pr_debug(" size:        %u\n", fs32_to_cpu(sb, usb1->fs_size));
+		pr_debug(" dsize:       %u\n", fs32_to_cpu(sb, usb1->fs_dsize));
+		pr_debug(" ncg:         %u\n", fs32_to_cpu(sb, usb1->fs_ncg));
+		pr_debug(" bsize:       %u\n", fs32_to_cpu(sb, usb1->fs_bsize));
+		pr_debug(" fsize:       %u\n", fs32_to_cpu(sb, usb1->fs_fsize));
+		pr_debug(" frag:        %u\n", fs32_to_cpu(sb, usb1->fs_frag));
+		pr_debug(" fragshift:   %u\n",
+			 fs32_to_cpu(sb, usb1->fs_fragshift));
+		pr_debug(" ~fmask:      %u\n", ~fs32_to_cpu(sb, usb1->fs_fmask));
+		pr_debug(" fshift:      %u\n", fs32_to_cpu(sb, usb1->fs_fshift));
+		pr_debug(" sbsize:      %u\n", fs32_to_cpu(sb, usb1->fs_sbsize));
+		pr_debug(" spc:         %u\n", fs32_to_cpu(sb, usb1->fs_spc));
+		pr_debug(" cpg:         %u\n", fs32_to_cpu(sb, usb1->fs_cpg));
+		pr_debug(" ipg:         %u\n", fs32_to_cpu(sb, usb1->fs_ipg));
+		pr_debug(" fpg:         %u\n", fs32_to_cpu(sb, usb1->fs_fpg));
+		pr_debug(" csaddr:      %u\n", fs32_to_cpu(sb, usb1->fs_csaddr));
+		pr_debug(" cssize:      %u\n", fs32_to_cpu(sb, usb1->fs_cssize));
+		pr_debug(" cgsize:      %u\n", fs32_to_cpu(sb, usb1->fs_cgsize));
+		pr_debug(" fstodb:      %u\n",
+			 fs32_to_cpu(sb, usb1->fs_fsbtodb));
+		pr_debug(" nrpos:       %u\n", fs32_to_cpu(sb, usb3->fs_nrpos));
+		pr_debug(" ndir         %u\n",
+			 fs32_to_cpu(sb, usb1->fs_cstotal.cs_ndir));
+		pr_debug(" nifree       %u\n",
+			 fs32_to_cpu(sb, usb1->fs_cstotal.cs_nifree));
+		pr_debug(" nbfree       %u\n",
+			 fs32_to_cpu(sb, usb1->fs_cstotal.cs_nbfree));
+		pr_debug(" nffree       %u\n",
+			 fs32_to_cpu(sb, usb1->fs_cstotal.cs_nffree));
 	}
-	printk("\n");
+	pr_debug("\n");
 }
 
 /*
@@ -247,38 +247,38 @@ static void ufs_print_super_stuff(struct
 static void ufs_print_cylinder_stuff(struct super_block *sb,
 				     struct ufs_cylinder_group *cg)
 {
-	printk("\nufs_print_cylinder_stuff\n");
-	printk("size of ucg: %zu\n", sizeof(struct ufs_cylinder_group));
-	printk("  magic:        %x\n", fs32_to_cpu(sb, cg->cg_magic));
-	printk("  time:         %u\n", fs32_to_cpu(sb, cg->cg_time));
-	printk("  cgx:          %u\n", fs32_to_cpu(sb, cg->cg_cgx));
-	printk("  ncyl:         %u\n", fs16_to_cpu(sb, cg->cg_ncyl));
-	printk("  niblk:        %u\n", fs16_to_cpu(sb, cg->cg_niblk));
-	printk("  ndblk:        %u\n", fs32_to_cpu(sb, cg->cg_ndblk));
-	printk("  cs_ndir:      %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_ndir));
-	printk("  cs_nbfree:    %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_nbfree));
-	printk("  cs_nifree:    %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_nifree));
-	printk("  cs_nffree:    %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_nffree));
-	printk("  rotor:        %u\n", fs32_to_cpu(sb, cg->cg_rotor));
-	printk("  frotor:       %u\n", fs32_to_cpu(sb, cg->cg_frotor));
-	printk("  irotor:       %u\n", fs32_to_cpu(sb, cg->cg_irotor));
-	printk("  frsum:        %u, %u, %u, %u, %u, %u, %u, %u\n",
+	pr_debug("\nufs_print_cylinder_stuff\n");
+	pr_debug("size of ucg: %zu\n", sizeof(struct ufs_cylinder_group));
+	pr_debug("  magic:        %x\n", fs32_to_cpu(sb, cg->cg_magic));
+	pr_debug("  time:         %u\n", fs32_to_cpu(sb, cg->cg_time));
+	pr_debug("  cgx:          %u\n", fs32_to_cpu(sb, cg->cg_cgx));
+	pr_debug("  ncyl:         %u\n", fs16_to_cpu(sb, cg->cg_ncyl));
+	pr_debug("  niblk:        %u\n", fs16_to_cpu(sb, cg->cg_niblk));
+	pr_debug("  ndblk:        %u\n", fs32_to_cpu(sb, cg->cg_ndblk));
+	pr_debug("  cs_ndir:      %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_ndir));
+	pr_debug("  cs_nbfree:    %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_nbfree));
+	pr_debug("  cs_nifree:    %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_nifree));
+	pr_debug("  cs_nffree:    %u\n", fs32_to_cpu(sb, cg->cg_cs.cs_nffree));
+	pr_debug("  rotor:        %u\n", fs32_to_cpu(sb, cg->cg_rotor));
+	pr_debug("  frotor:       %u\n", fs32_to_cpu(sb, cg->cg_frotor));
+	pr_debug("  irotor:       %u\n", fs32_to_cpu(sb, cg->cg_irotor));
+	pr_debug("  frsum:        %u, %u, %u, %u, %u, %u, %u, %u\n",
 	    fs32_to_cpu(sb, cg->cg_frsum[0]), fs32_to_cpu(sb, cg->cg_frsum[1]),
 	    fs32_to_cpu(sb, cg->cg_frsum[2]), fs32_to_cpu(sb, cg->cg_frsum[3]),
 	    fs32_to_cpu(sb, cg->cg_frsum[4]), fs32_to_cpu(sb, cg->cg_frsum[5]),
 	    fs32_to_cpu(sb, cg->cg_frsum[6]), fs32_to_cpu(sb, cg->cg_frsum[7]));
-	printk("  btotoff:      %u\n", fs32_to_cpu(sb, cg->cg_btotoff));
-	printk("  boff:         %u\n", fs32_to_cpu(sb, cg->cg_boff));
-	printk("  iuseoff:      %u\n", fs32_to_cpu(sb, cg->cg_iusedoff));
-	printk("  freeoff:      %u\n", fs32_to_cpu(sb, cg->cg_freeoff));
-	printk("  nextfreeoff:  %u\n", fs32_to_cpu(sb, cg->cg_nextfreeoff));
-	printk("  clustersumoff %u\n",
-	       fs32_to_cpu(sb, cg->cg_u.cg_44.cg_clustersumoff));
-	printk("  clusteroff    %u\n",
-	       fs32_to_cpu(sb, cg->cg_u.cg_44.cg_clusteroff));
-	printk("  nclusterblks  %u\n",
-	       fs32_to_cpu(sb, cg->cg_u.cg_44.cg_nclusterblks));
-	printk("\n");
+	pr_debug("  btotoff:      %u\n", fs32_to_cpu(sb, cg->cg_btotoff));
+	pr_debug("  boff:         %u\n", fs32_to_cpu(sb, cg->cg_boff));
+	pr_debug("  iuseoff:      %u\n", fs32_to_cpu(sb, cg->cg_iusedoff));
+	pr_debug("  freeoff:      %u\n", fs32_to_cpu(sb, cg->cg_freeoff));
+	pr_debug("  nextfreeoff:  %u\n", fs32_to_cpu(sb, cg->cg_nextfreeoff));
+	pr_debug("  clustersumoff %u\n",
+		 fs32_to_cpu(sb, cg->cg_u.cg_44.cg_clustersumoff));
+	pr_debug("  clusteroff    %u\n",
+		 fs32_to_cpu(sb, cg->cg_u.cg_44.cg_clusteroff));
+	pr_debug("  nclusterblks  %u\n",
+		 fs32_to_cpu(sb, cg->cg_u.cg_44.cg_nclusterblks));
+	pr_debug("\n");
 }
 #else
 #  define ufs_print_super_stuff(sb, usb1, usb2, usb3) /**/
@@ -316,7 +316,7 @@ void ufs_error (struct super_block * sb,
 	case UFS_MOUNT_ONERROR_LOCK:
 	case UFS_MOUNT_ONERROR_UMOUNT:
 	case UFS_MOUNT_ONERROR_REPAIR:
-		printk (KERN_CRIT "UFS-fs error (device %s): %s: %s\n",
+		pr_crit("UFS-fs error (device %s): %s: %s\n",
 			sb->s_id, function, error_buf);
 	}		
 }
@@ -340,7 +340,7 @@ void ufs_panic (struct super_block * sb,
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
 	sb->s_flags |= MS_RDONLY;
-	printk (KERN_CRIT "UFS-fs panic (device %s): %s: %s\n",
+	pr_crit("UFS-fs panic (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -352,7 +352,7 @@ void ufs_warning (struct super_block * s
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
-	printk (KERN_WARNING "UFS-fs warning (device %s): %s: %s\n",
+	pr_warn("UFS-fs warning (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -464,14 +464,12 @@ static int ufs_parse_options (char * opt
 			ufs_set_opt (*mount_options, ONERROR_UMOUNT);
 			break;
 		case Opt_onerror_repair:
-			printk("UFS-fs: Unable to do repair on error, "
-				"will lock lock instead\n");
+			pr_err("UFS-fs: Unable to do repair on error, will lock lock instead\n");
 			ufs_clear_opt (*mount_options, ONERROR);
 			ufs_set_opt (*mount_options, ONERROR_REPAIR);
 			break;
 		default:
-			printk("UFS-fs: Invalid option: \"%s\" "
-					"or missing value\n", p);
+			pr_err("UFS-fs: Invalid option: \"%s\" or missing value\n", p);
 			return 0;
 		}
 	}
@@ -788,8 +786,7 @@ static int ufs_fill_super(struct super_b
 
 #ifndef CONFIG_UFS_FS_WRITE
 	if (!(sb->s_flags & MS_RDONLY)) {
-		printk("ufs was compiled with read-only support, "
-		       "can't be mounted as read-write\n");
+		pr_err("ufs was compiled with read-only support, can't be mounted as read-write\n");
 		return -EROFS;
 	}
 #endif
@@ -812,12 +809,12 @@ static int ufs_fill_super(struct super_b
 	sbi->s_mount_opt = 0;
 	ufs_set_opt (sbi->s_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options ((char *) data, &sbi->s_mount_opt)) {
-		printk("wrong mount options\n");
+		pr_err("wrong mount options\n");
 		goto failed;
 	}
 	if (!(sbi->s_mount_opt & UFS_MOUNT_UFSTYPE)) {
 		if (!silent)
-			printk("You didn't specify the type of your ufs filesystem\n\n"
+			pr_err("You didn't specify the type of your ufs filesystem\n\n"
 			"mount -t ufs -o ufstype="
 			"sun|sunx86|44bsd|ufs2|5xbsd|old|hp|nextstep|nextstep-cd|openstep ...\n\n"
 			">>>WARNING<<< Wrong ufstype may corrupt your filesystem, "
@@ -900,7 +897,7 @@ static int ufs_fill_super(struct super_b
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
-				printk(KERN_INFO "ufstype=old is supported read-only\n");
+				pr_info("ufstype=old is supported read-only\n");
 			sb->s_flags |= MS_RDONLY;
 		}
 		break;
@@ -916,7 +913,7 @@ static int ufs_fill_super(struct super_b
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
-				printk(KERN_INFO "ufstype=nextstep is supported read-only\n");
+				pr_info("ufstype=nextstep is supported read-only\n");
 			sb->s_flags |= MS_RDONLY;
 		}
 		break;
@@ -932,7 +929,7 @@ static int ufs_fill_super(struct super_b
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
-				printk(KERN_INFO "ufstype=nextstep-cd is supported read-only\n");
+				pr_info("ufstype=nextstep-cd is supported read-only\n");
 			sb->s_flags |= MS_RDONLY;
 		}
 		break;
@@ -948,7 +945,7 @@ static int ufs_fill_super(struct super_b
 		flags |= UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
-				printk(KERN_INFO "ufstype=openstep is supported read-only\n");
+				pr_info("ufstype=openstep is supported read-only\n");
 			sb->s_flags |= MS_RDONLY;
 		}
 		break;
@@ -963,19 +960,19 @@ static int ufs_fill_super(struct super_b
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
-				printk(KERN_INFO "ufstype=hp is supported read-only\n");
+				pr_info("ufstype=hp is supported read-only\n");
 			sb->s_flags |= MS_RDONLY;
  		}
  		break;
 	default:
 		if (!silent)
-			printk("unknown ufstype\n");
+			pr_err("unknown ufstype\n");
 		goto failed;
 	}
 	
 again:	
 	if (!sb_set_blocksize(sb, block_size)) {
-		printk(KERN_ERR "UFS: failed to set blocksize\n");
+		pr_err("UFS: failed to set blocksize\n");
 		goto failed;
 	}
 
@@ -1034,7 +1031,7 @@ again:
 		goto again;
 	}
 	if (!silent)
-		printk("ufs_read_super: bad magic number\n");
+		pr_err("ufs_read_super: bad magic number\n");
 	goto failed;
 
 magic_found:
@@ -1048,33 +1045,33 @@ magic_found:
 	uspi->s_fshift = fs32_to_cpu(sb, usb1->fs_fshift);
 
 	if (!is_power_of_2(uspi->s_fsize)) {
-		printk(KERN_ERR "ufs_read_super: fragment size %u is not a power of 2\n",
-			uspi->s_fsize);
-			goto failed;
+		pr_err("ufs_read_super: fragment size %u is not a power of 2\n",
+		       uspi->s_fsize);
+		goto failed;
 	}
 	if (uspi->s_fsize < 512) {
-		printk(KERN_ERR "ufs_read_super: fragment size %u is too small\n",
-			uspi->s_fsize);
+		pr_err("ufs_read_super: fragment size %u is too small\n",
+		       uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize > 4096) {
-		printk(KERN_ERR "ufs_read_super: fragment size %u is too large\n",
-			uspi->s_fsize);
+		pr_err("ufs_read_super: fragment size %u is too large\n",
+		       uspi->s_fsize);
 		goto failed;
 	}
 	if (!is_power_of_2(uspi->s_bsize)) {
-		printk(KERN_ERR "ufs_read_super: block size %u is not a power of 2\n",
-			uspi->s_bsize);
+		pr_err("ufs_read_super: block size %u is not a power of 2\n",
+		       uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize < 4096) {
-		printk(KERN_ERR "ufs_read_super: block size %u is too small\n",
-			uspi->s_bsize);
+		pr_err("ufs_read_super: block size %u is too small\n",
+		       uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize / uspi->s_fsize > 8) {
-		printk(KERN_ERR "ufs_read_super: too many fragments per block (%u)\n",
-			uspi->s_bsize / uspi->s_fsize);
+		pr_err("ufs_read_super: too many fragments per block (%u)\n",
+		       uspi->s_bsize / uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize != block_size || uspi->s_sbsize != super_block_size) {
@@ -1113,20 +1110,21 @@ magic_found:
 			UFSD("fs is DEC OSF/1\n");
 			break;
 		case UFS_FSACTIVE:
-			printk("ufs_read_super: fs is active\n");
+			pr_err("ufs_read_super: fs is active\n");
 			sb->s_flags |= MS_RDONLY;
 			break;
 		case UFS_FSBAD:
-			printk("ufs_read_super: fs is bad\n");
+			pr_err("ufs_read_super: fs is bad\n");
 			sb->s_flags |= MS_RDONLY;
 			break;
 		default:
-			printk("ufs_read_super: can't grok fs_clean 0x%x\n", usb1->fs_clean);
+			pr_err("ufs_read_super: can't grok fs_clean 0x%x\n",
+			       usb1->fs_clean);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		}
 	} else {
-		printk("ufs_read_super: fs needs fsck\n");
+		pr_err("ufs_read_super: fs needs fsck\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
@@ -1299,7 +1297,7 @@ static int ufs_remount (struct super_blo
 	if (!(new_mount_opt & UFS_MOUNT_UFSTYPE)) {
 		new_mount_opt |= ufstype;
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
-		printk("ufstype can't be changed during remount\n");
+		pr_err("ufstype can't be changed during remount\n");
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
@@ -1328,8 +1326,7 @@ static int ufs_remount (struct super_blo
 	 * fs was mounted as ro, remounting rw
 	 */
 #ifndef CONFIG_UFS_FS_WRITE
-		printk("ufs was compiled with read-only support, "
-		"can't be mounted as read-write\n");
+		pr_err("ufs was compiled with read-only support, can't be mounted as read-write\n");
 		unlock_ufs(sb);
 		return -EINVAL;
 #else
@@ -1338,12 +1335,12 @@ static int ufs_remount (struct super_blo
 		    ufstype != UFS_MOUNT_UFSTYPE_44BSD &&
 		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
-			printk("this ufstype is read-only supported\n");
+			pr_err("this ufstype is read-only supported\n");
 			unlock_ufs(sb);
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
-			printk("failed during remounting\n");
+			pr_err("failed during remounting\n");
 			unlock_ufs(sb);
 			return -EPERM;
 		}
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

