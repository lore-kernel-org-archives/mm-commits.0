From: akpm@linux-foundation.org
Subject: - uml-make-three-functions-static.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:58 -0700
Message-ID: <200804282154.m3SLswjH018055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934890AbYD1VzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: make three functions static
has been removed from the -mm tree.  Its filename was
     uml-make-three-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: make three functions static
From: WANG Cong <xiyou.wangcong@gmail.com>

Make the following three functions static, since they don't need to be global.

arch/um/drivers/mcast_kern.c::mcast_setup()
arch/um/drivers/mconsole_user.c::mconsole_reply_v0()
arch/um/drivers/port_user.c::port_pre_exec()

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mcast_kern.c    |    2 +-
 arch/um/drivers/mconsole_user.c |    2 +-
 arch/um/drivers/port_user.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/mcast_kern.c~uml-make-three-functions-static arch/um/drivers/mcast_kern.c
--- a/arch/um/drivers/mcast_kern.c~uml-make-three-functions-static
+++ a/arch/um/drivers/mcast_kern.c
@@ -58,7 +58,7 @@ static const struct net_kern_info mcast_
 	.write			= mcast_write,
 };
 
-int mcast_setup(char *str, char **mac_out, void *data)
+static int mcast_setup(char *str, char **mac_out, void *data)
 {
 	struct mcast_init *init = data;
 	char *port_str = NULL, *ttl_str = NULL, *remain;
diff -puN arch/um/drivers/mconsole_user.c~uml-make-three-functions-static arch/um/drivers/mconsole_user.c
--- a/arch/um/drivers/mconsole_user.c~uml-make-three-functions-static
+++ a/arch/um/drivers/mconsole_user.c
@@ -39,7 +39,7 @@ static struct mconsole_command commands[
 /* Initialized in mconsole_init, which is an initcall */
 char mconsole_socket_name[256];
 
-int mconsole_reply_v0(struct mc_request *req, char *reply)
+static int mconsole_reply_v0(struct mc_request *req, char *reply)
 {
 	struct iovec iov;
 	struct msghdr msg;
diff -puN arch/um/drivers/port_user.c~uml-make-three-functions-static arch/um/drivers/port_user.c
--- a/arch/um/drivers/port_user.c~uml-make-three-functions-static
+++ a/arch/um/drivers/port_user.c
@@ -153,7 +153,7 @@ struct port_pre_exec_data {
 	int pipe_fd;
 };
 
-void port_pre_exec(void *arg)
+static void port_pre_exec(void *arg)
 {
 	struct port_pre_exec_data *data = arg;
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

