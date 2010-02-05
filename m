From: akpm@linux-foundation.org
Subject: [merged] net-rds-remove-uses-of-nipquad-use-%pi4.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:59:00 -0800
Message-ID: <201002051959.o15Jx0JE017921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933842Ab0BET7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andy.grover@oracle.com, mm-commits@vger.kernel.org


The patch titled
     net/rds: remove uses of NIPQUAD, use %pI4
has been removed from the -mm tree.  Its filename was
     net-rds-remove-uses-of-nipquad-use-%pi4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/rds: remove uses of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Grover <andy.grover@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rds/tcp_connect.c |    7 +++----
 net/rds/tcp_listen.c  |    6 +++---
 net/rds/tcp_send.c    |    4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff -puN net/rds/tcp_connect.c~net-rds-remove-uses-of-nipquad-use-%pi4 net/rds/tcp_connect.c
--- a/net/rds/tcp_connect.c~net-rds-remove-uses-of-nipquad-use-%pi4
+++ a/net/rds/tcp_connect.c
@@ -90,8 +90,8 @@ int rds_tcp_conn_connect(struct rds_conn
 
 	ret = sock->ops->bind(sock, (struct sockaddr *)&src, sizeof(src));
 	if (ret) {
-		rdsdebug("bind failed with %d at address %u.%u.%u.%u\n",
-		     ret, NIPQUAD(conn->c_laddr));
+		rdsdebug("bind failed with %d at address %pI4\n",
+			 ret, &conn->c_laddr);
 		goto out;
 	}
 
@@ -108,8 +108,7 @@ int rds_tcp_conn_connect(struct rds_conn
 				 O_NONBLOCK);
 	sock = NULL;
 
-	rdsdebug("connect to address %u.%u.%u.%u returned %d\n",
-		 NIPQUAD(conn->c_faddr), ret);
+	rdsdebug("connect to address %pI4 returned %d\n", &conn->c_faddr, ret);
 	if (ret == -EINPROGRESS)
 		ret = 0;
 
diff -puN net/rds/tcp_listen.c~net-rds-remove-uses-of-nipquad-use-%pi4 net/rds/tcp_listen.c
--- a/net/rds/tcp_listen.c~net-rds-remove-uses-of-nipquad-use-%pi4
+++ a/net/rds/tcp_listen.c
@@ -66,9 +66,9 @@ static int rds_tcp_accept_one(struct soc
 
 	inet = inet_sk(new_sock->sk);
 
-	rdsdebug("accepted tcp %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u\n",
-		  NIPQUAD(inet->inet_saddr), ntohs(inet->inet_sport),
-		  NIPQUAD(inet->inet_daddr), ntohs(inet->inet_dport));
+	rdsdebug("accepted tcp %pI4:%u -> %pI4:%u\n",
+		 &inet->inet_saddr, ntohs(inet->inet_sport),
+		 &inet->inet_daddr, ntohs(inet->inet_dport));
 
 	conn = rds_conn_create(inet->inet_saddr, inet->inet_daddr,
 			       &rds_tcp_transport, GFP_KERNEL);
diff -puN net/rds/tcp_send.c~net-rds-remove-uses-of-nipquad-use-%pi4 net/rds/tcp_send.c
--- a/net/rds/tcp_send.c~net-rds-remove-uses-of-nipquad-use-%pi4
+++ a/net/rds/tcp_send.c
@@ -193,9 +193,9 @@ out:
 			rds_tcp_stats_inc(s_tcp_sndbuf_full);
 			ret = 0;
 		} else {
-			printk(KERN_WARNING "RDS/tcp: send to %u.%u.%u.%u "
+			printk(KERN_WARNING "RDS/tcp: send to %pI4 "
 			       "returned %d, disconnecting and reconnecting\n",
-			       NIPQUAD(conn->c_faddr), ret);
+			       &conn->c_faddr, ret);
 			rds_conn_drop(conn);
 		}
 	}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
arch-ia64-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-staging-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
scripts-checkpatchpl-dramatically-improve-define-parse-times.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch
drivers-video-via-fix-continuation-line-formats.patch

