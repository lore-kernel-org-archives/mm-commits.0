From: akpm@linux-foundation.org
Subject: + uml-driver-formatting-fixes.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:23:49 -0800
Message-ID: <200703070123.l271NnHb015416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42002 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161130AbXCGBXy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:23:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: driver formatting fixes
has been added to the -mm tree.  Its filename is
     uml-driver-formatting-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: driver formatting fixes
From: Jeff Dike <jdike@addtoit.com>

Fix a bunch of formatting violations in the drivers:
	return(n) -> return n
	whitespace fixes
	emacs formatting comment removal
	breaking if(foo) return(n) into two lines

There are also a couple of errno use bugs:
	using errno in a printk when the failure put errno into a local variable
	saving errno after a printk, which can change it

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c              |    2 -
 arch/um/drivers/daemon_user.c            |   25 +++----------
 arch/um/drivers/mcast_user.c             |   12 +++---
 arch/um/drivers/pcap_user.c              |   33 +++++------------
 arch/um/drivers/ubd_user.c               |   15 +------
 arch/um/os-Linux/drivers/ethertap_user.c |   36 +++++++-----------
 arch/um/os-Linux/drivers/tuntap_user.c   |   40 ++++++++-------------
 7 files changed, 57 insertions(+), 106 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-driver-formatting-fixes arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-driver-formatting-fixes
+++ a/arch/um/drivers/chan_user.c
@@ -158,7 +158,7 @@ static int winch_tramp(int fd, struct tt
 	 */
 	err = run_helper_thread(winch_thread, &data, CLONE_FILES, &stack, 0);
 	if(err < 0){
-		printk("fork of winch_thread failed - errno = %d\n", errno);
+		printk("fork of winch_thread failed - errno = %d\n", err);
 		goto out_close;
 	}
 
diff -puN arch/um/drivers/daemon_user.c~uml-driver-formatting-fixes arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-driver-formatting-fixes
+++ a/arch/um/drivers/daemon_user.c
@@ -39,11 +39,11 @@ static struct sockaddr_un *new_addr(void
 	sun = um_kmalloc(sizeof(struct sockaddr_un));
 	if(sun == NULL){
 		printk("new_addr: allocation of sockaddr_un failed\n");
-		return(NULL);
+		return NULL;
 	}
 	sun->sun_family = AF_UNIX;
 	memcpy(sun->sun_path, name, len);
-	return(sun);
+	return sun;
 }
 
 static int connect_to_switch(struct daemon_data *pri)
@@ -112,7 +112,7 @@ static int connect_to_switch(struct daem
 	}
 
 	pri->data_addr = sun;
-	return(fd);
+	return fd;
 
  out_free:
 	kfree(sun);
@@ -120,7 +120,7 @@ static int connect_to_switch(struct daem
 	os_close_file(fd);
  out:
 	os_close_file(pri->control);
-	return(err);
+	return err;
 }
 
 static void daemon_user_init(void *data, void *dev)
@@ -152,7 +152,7 @@ static void daemon_user_init(void *data,
 static int daemon_open(void *data)
 {
 	struct daemon_data *pri = data;
-	return(pri->fd);
+	return pri->fd;
 }
 
 static void daemon_remove(void *data)
@@ -176,12 +176,12 @@ int daemon_user_write(int fd, void *buf,
 {
 	struct sockaddr_un *data_addr = pri->data_addr;
 
-	return(net_sendto(fd, buf, len, data_addr, sizeof(*data_addr)));
+	return net_sendto(fd, buf, len, data_addr, sizeof(*data_addr));
 }
 
 static int daemon_set_mtu(int mtu, void *data)
 {
-	return(mtu);
+	return mtu;
 }
 
 const struct net_user_info daemon_user_info = {
@@ -194,14 +194,3 @@ const struct net_user_info daemon_user_i
 	.delete_address = NULL,
 	.max_packet	= MAX_PACKET - ETH_HEADER_OTHER
 };
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/mcast_user.c~uml-driver-formatting-fixes arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-driver-formatting-fixes
+++ a/arch/um/drivers/mcast_user.c
@@ -34,12 +34,12 @@ static struct sockaddr_in *new_addr(char
 	sin = um_kmalloc(sizeof(struct sockaddr_in));
 	if(sin == NULL){
 		printk("new_addr: allocation of sockaddr_in failed\n");
-		return(NULL);
+		return NULL;
 	}
 	sin->sin_family = AF_INET;
 	sin->sin_addr.s_addr = in_aton(addr);
 	sin->sin_port = htons(port);
-	return(sin);
+	return sin;
 }
 
 static void mcast_user_init(void *data, void *dev)
@@ -107,8 +107,8 @@ static int mcast_open(void *data)
 		err = -errno;
 		printk("mcast_open : data bind failed, errno = %d\n", errno);
 		goto out_close;
-	}		
-	
+	}
+
 	/* subscribe to the multicast group */
 	mreq.imr_multiaddr.s_addr = sin->sin_addr.s_addr;
 	mreq.imr_interface.s_addr = 0;
@@ -153,12 +153,12 @@ int mcast_user_write(int fd, void *buf, 
 {
 	struct sockaddr_in *data_addr = pri->mcast_addr;
 
-	return(net_sendto(fd, buf, len, data_addr, sizeof(*data_addr)));
+	return net_sendto(fd, buf, len, data_addr, sizeof(*data_addr));
 }
 
 static int mcast_set_mtu(int mtu, void *data)
 {
-	return(mtu);
+	return mtu;
 }
 
 const struct net_user_info mcast_user_info = {
diff -puN arch/um/drivers/pcap_user.c~uml-driver-formatting-fixes arch/um/drivers/pcap_user.c
--- a/arch/um/drivers/pcap_user.c~uml-driver-formatting-fixes
+++ a/arch/um/drivers/pcap_user.c
@@ -42,39 +42,39 @@ static int pcap_open(void *data)
 	int err;
 
 	if(pri->pcap == NULL)
-		return(-ENODEV);
+		return -ENODEV;
 
 	if(pri->filter != NULL){
 		err = dev_netmask(pri->dev, &netmask);
 		if(err < 0){
 			printk("pcap_open : dev_netmask failed\n");
-			return(-EIO);
+			return -EIO;
 		}
 
 		pri->compiled = um_kmalloc(sizeof(struct bpf_program));
 		if(pri->compiled == NULL){
 			printk("pcap_open : kmalloc failed\n");
-			return(-ENOMEM);
+			return -ENOMEM;
 		}
-		
+
 		err = pcap_compile(pri->pcap, 
 				   (struct bpf_program *) pri->compiled, 
 				   pri->filter, pri->optimize, netmask);
 		if(err < 0){
 			printk("pcap_open : pcap_compile failed - '%s'\n", 
 			       pcap_geterr(pri->pcap));
-			return(-EIO);
+			return -EIO;
 		}
 
 		err = pcap_setfilter(pri->pcap, pri->compiled);
 		if(err < 0){
 			printk("pcap_open : pcap_setfilter failed - '%s'\n", 
 			       pcap_geterr(pri->pcap));
-			return(-EIO);
+			return -EIO;
 		}
 	}
-	
-	return(PCAP_FD(pri->pcap));
+
+	return PCAP_FD(pri->pcap);
 }
 
 static void pcap_remove(void *data)
@@ -114,11 +114,11 @@ int pcap_user_read(int fd, void *buffer,
 	n = pcap_dispatch(pri->pcap, 1, handler, (u_char *) &hdata);
 	if(n < 0){
 		printk("pcap_dispatch failed - %s\n", pcap_geterr(pri->pcap));
-		return(-EIO);
+		return -EIO;
 	}
 	else if(n == 0) 
-		return(0);
-	return(hdata.len);
+		return 0;
+	return hdata.len;
 }
 
 const struct net_user_info pcap_user_info = {
@@ -131,14 +131,3 @@ const struct net_user_info pcap_user_inf
 	.delete_address = NULL,
 	.max_packet	= MAX_PACKET - ETH_HEADER_OTHER
 };
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/ubd_user.c~uml-driver-formatting-fixes arch/um/drivers/ubd_user.c
--- a/arch/um/drivers/ubd_user.c~uml-driver-formatting-fixes
+++ a/arch/um/drivers/ubd_user.c
@@ -47,8 +47,8 @@ int start_io_thread(unsigned long sp, in
 	pid = clone(io_thread, (void *) sp, CLONE_FILES | CLONE_VM | SIGCHLD,
 		    NULL);
 	if(pid < 0){
-		printk("start_io_thread - clone failed : errno = %d\n", errno);
 		err = -errno;
+		printk("start_io_thread - clone failed : errno = %d\n", errno);
 		goto out_close;
 	}
 
@@ -60,16 +60,5 @@ int start_io_thread(unsigned long sp, in
 	kernel_fd = -1;
 	*fd_out = -1;
  out:
-	return(err);
+	return err;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-driver-formatting-fixes arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-driver-formatting-fixes
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -121,7 +121,7 @@ static int etap_tramp(char *dev, char *g
 	n = os_read_file(control_me, &c, sizeof(c));
 	if(n != sizeof(c)){
 		printk("etap_tramp : read of status failed, err = %d\n", -n);
-		return(-EINVAL);
+		return -EINVAL;
 	}
 	if(c != 1){
 		printk("etap_tramp : uml_net failed\n");
@@ -132,7 +132,7 @@ static int etap_tramp(char *dev, char *g
 		else if(!WIFEXITED(status) || (WEXITSTATUS(status) != 1))
 			printk("uml_net didn't exit with status 1\n");
 	}
-	return(err);
+	return err;
 }
 
 static int etap_open(void *data)
@@ -142,20 +142,21 @@ static int etap_open(void *data)
 	int data_fds[2], control_fds[2], err, output_len;
 
 	err = tap_open_common(pri->dev, pri->gate_addr);
-	if(err) return(err);
+	if(err)
+		return err;
 
 	err = os_pipe(data_fds, 0, 0);
 	if(err < 0){
 		printk("data os_pipe failed - err = %d\n", -err);
-		return(err);
+		return err;
 	}
 
 	err = os_pipe(control_fds, 1, 0);
 	if(err < 0){
 		printk("control os_pipe failed - err = %d\n", -err);
-		return(err);
+		return err;
 	}
-	
+
 	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0], 
 			 control_fds[1], data_fds[0], data_fds[1]);
 	output_len = page_size();
@@ -171,13 +172,13 @@ static int etap_open(void *data)
 
 	if(err < 0){
 		printk("etap_tramp failed - err = %d\n", -err);
-		return(err);
+		return err;
 	}
 
 	pri->data_fd = data_fds[0];
 	pri->control_fd = control_fds[0];
 	iter_addresses(pri->dev, etap_open_addr, &pri->control_fd);
-	return(data_fds[0]);
+	return data_fds[0];
 }
 
 static void etap_close(int fd, void *data)
@@ -195,7 +196,7 @@ static void etap_close(int fd, void *dat
 
 static int etap_set_mtu(int mtu, void *data)
 {
-	return(mtu);
+	return mtu;
 }
 
 static void etap_add_addr(unsigned char *addr, unsigned char *netmask,
@@ -204,7 +205,8 @@ static void etap_add_addr(unsigned char 
 	struct ethertap_data *pri = data;
 
 	tap_check_ips(pri->gate_addr, addr);
-	if(pri->control_fd == -1) return;
+	if(pri->control_fd == -1)
+		return;
 	etap_open_addr(addr, netmask, &pri->control_fd);
 }
 
@@ -213,7 +215,8 @@ static void etap_del_addr(unsigned char 
 {
 	struct ethertap_data *pri = data;
 
-	if(pri->control_fd == -1) return;
+	if(pri->control_fd == -1)
+		return;
 	etap_close_addr(addr, netmask, &pri->control_fd);
 }
 
@@ -227,14 +230,3 @@ const struct net_user_info ethertap_user
 	.delete_address = etap_del_addr,
 	.max_packet	= MAX_PACKET - ETH_HEADER_ETHERTAP
 };
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-driver-formatting-fixes arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-driver-formatting-fixes
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -37,7 +37,8 @@ static void tuntap_add_addr(unsigned cha
 	struct tuntap_data *pri = data;
 
 	tap_check_ips(pri->gate_addr, addr);
-	if((pri->fd == -1) || pri->fixed_config) return;
+	if((pri->fd == -1) || pri->fixed_config)
+		return;
 	open_addr(addr, netmask, pri->dev_name);
 }
 
@@ -46,7 +47,8 @@ static void tuntap_del_addr(unsigned cha
 {
 	struct tuntap_data *pri = data;
 
-	if((pri->fd == -1) || pri->fixed_config) return;
+	if((pri->fd == -1) || pri->fixed_config)
+		return;
 	close_addr(addr, netmask, pri->dev_name);
 }
 
@@ -58,7 +60,7 @@ struct tuntap_pre_exec_data {
 static void tuntap_pre_exec(void *arg)
 {
 	struct tuntap_pre_exec_data *data = arg;
-	
+
 	dup2(data->stdout, 1);
 	os_close_file(data->close_me);
 }
@@ -83,7 +85,8 @@ static int tuntap_open_tramp(char *gate,
 
 	pid = run_helper(tuntap_pre_exec, &data, argv, NULL);
 
-	if(pid < 0) return(-pid);
+	if(pid < 0)
+		return -pid;
 
 	os_close_file(remote);
 
@@ -114,16 +117,16 @@ static int tuntap_open_tramp(char *gate,
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if(cmsg == NULL){
 		printk("tuntap_open_tramp : didn't receive a message\n");
-		return(-EINVAL);
+		return -EINVAL;
 	}
 	if((cmsg->cmsg_level != SOL_SOCKET) || 
 	   (cmsg->cmsg_type != SCM_RIGHTS)){
 		printk("tuntap_open_tramp : didn't receive a descriptor\n");
-		return(-EINVAL);
+		return -EINVAL;
 	}
 	*fd_out = ((int *) CMSG_DATA(cmsg))[0];
 	os_set_exec_close(*fd_out, 1);
-	return(0);
+	return 0;
 }
 
 static int tuntap_open(void *data)
@@ -135,7 +138,7 @@ static int tuntap_open(void *data)
 
 	err = tap_open_common(pri->dev, pri->gate_addr);
 	if(err < 0)
-		return(err);
+		return err;
 
 	if(pri->fixed_config){
 		pri->fd = os_open_file("/dev/net/tun",
@@ -143,7 +146,7 @@ static int tuntap_open(void *data)
 		if(pri->fd < 0){
 			printk("Failed to open /dev/net/tun, err = %d\n",
 			       -pri->fd);
-			return(pri->fd);
+			return pri->fd;
 		}
 		memset(&ifr, 0, sizeof(ifr));
 		ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
@@ -160,7 +163,7 @@ static int tuntap_open(void *data)
 		if(err < 0){
 			printk("tuntap_open : os_pipe failed - err = %d\n",
 			       -err);
-			return(err);
+			return err;
 		}
 
 		buffer = get_output_buffer(&len);
@@ -175,7 +178,7 @@ static int tuntap_open(void *data)
 			printk("%s", output);
 			free_output_buffer(buffer);
 			printk("tuntap_open_tramp failed - err = %d\n", -err);
-			return(err);
+			return err;
 		}
 
 		pri->dev_name = uml_strdup(buffer);
@@ -187,7 +190,7 @@ static int tuntap_open(void *data)
 		iter_addresses(pri->dev, open_addr, pri->dev_name);
 	}
 
-	return(pri->fd);
+	return pri->fd;
 }
 
 static void tuntap_close(int fd, void *data)
@@ -202,7 +205,7 @@ static void tuntap_close(int fd, void *d
 
 static int tuntap_set_mtu(int mtu, void *data)
 {
-	return(mtu);
+	return mtu;
 }
 
 const struct net_user_info tuntap_user_info = {
@@ -215,14 +218,3 @@ const struct net_user_info tuntap_user_i
 	.delete_address = tuntap_del_addr,
 	.max_packet	= MAX_PACKET
 };
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-audith-needs-linux-typesh.patch
uml-fix-formatting-violations-in-signal-delivery-code.patch
uml-add-a-debugging-message.patch
uml-comment-the-initialization-of-a-global.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-fix-prototypes.patch
uml-network-interface-hotplug-error-handling.patch
