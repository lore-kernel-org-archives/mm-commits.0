From: akpm@osdl.org
Subject: + git-nfs-fixup.patch added to -mm tree
Date: Wed, 06 Dec 2006 14:02:51 -0800
Message-ID: <200612062202.kB6M2plE017926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937695AbWLFWCy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:02:54 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kB6M2pID003016
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 6 Dec 2006 14:02:52 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org


The patch titled
     git-nfs-fixup
has been added to the -mm tree.  Its filename is
     git-nfs-fixup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-nfs-fixup
From: Andrew Morton <akpm@osdl.org>

make nfs trainwreck compile.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sunrpc/xprt.h |    3 
 net/sunrpc/xprtsock.c       |  247 ----------------------------------
 2 files changed, 1 insertion(+), 249 deletions(-)

diff -puN include/linux/sunrpc/xprt.h~git-nfs-fixup include/linux/sunrpc/xprt.h
--- a/include/linux/sunrpc/xprt.h~git-nfs-fixup
+++ a/include/linux/sunrpc/xprt.h
@@ -157,11 +157,8 @@ struct rpc_xprt {
 	unsigned long		connect_timeout,
 				bind_timeout,
 				reestablish_timeout;
-<<<<<<< HEAD/include/linux/sunrpc/xprt.h
 	struct delayed_work	connect_worker;
 	unsigned short		port;
-=======
->>>>>>> /include/linux/sunrpc/xprt.h
 
 	/*
 	 * Disconnection of idle transports
diff -puN net/sunrpc/xprtsock.c~git-nfs-fixup net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~git-nfs-fixup
+++ a/net/sunrpc/xprtsock.c
@@ -654,7 +654,7 @@ static void xs_destroy(struct rpc_xprt *
 
 	dprintk("RPC:      xs_destroy xprt %p\n", xprt);
 
-	cancel_delayed_work(&transport->connect_worker);
+//	cancel_delayed_work(&transport->connect_worker);
 	flush_scheduled_work();
 
 	xprt_disconnect(xprt);
@@ -1181,63 +1181,6 @@ static int xs_bindresvport(struct sock_x
  */
 static void xs_udp_connect_worker(struct work_struct *work)
 {
-<<<<<<< HEAD/net/sunrpc/xprtsock.c
-	struct rpc_xprt *xprt =
-		container_of(work, struct rpc_xprt, connect_worker.work);
-	struct socket *sock = xprt->sock;
-=======
-	struct sock_xprt *transport = (struct sock_xprt *)args;
-	struct rpc_xprt *xprt = &transport->xprt;
-	struct socket *sock = transport->sock;
->>>>>>> /net/sunrpc/xprtsock.c
-	int err, status = -EIO;
-
-	if (xprt->shutdown || !xprt_bound(xprt))
-		goto out;
-
-	/* Start by resetting any existing state */
-	xs_close(xprt);
-
-	if ((err = sock_create_kern(PF_INET, SOCK_DGRAM, IPPROTO_UDP, &sock)) < 0) {
-		dprintk("RPC:      can't create UDP transport socket (%d).\n", -err);
-		goto out;
-	}
-
-	if (xprt->resvport && xs_bindresvport(transport, sock) < 0) {
-		sock_release(sock);
-		goto out;
-	}
-
-	dprintk("RPC:      worker connecting xprt %p to address: %s\n",
-			xprt, xprt->address_strings[RPC_DISPLAY_ALL]);
-
-	if (!transport->inet) {
-		struct sock *sk = sock->sk;
-
-		write_lock_bh(&sk->sk_callback_lock);
-
-		sk->sk_user_data = xprt;
-		transport->old_data_ready = sk->sk_data_ready;
-		transport->old_state_change = sk->sk_state_change;
-		transport->old_write_space = sk->sk_write_space;
-		sk->sk_data_ready = xs_udp_data_ready;
-		sk->sk_write_space = xs_udp_write_space;
-		sk->sk_no_check = UDP_CSUM_NORCV;
-		sk->sk_allocation = GFP_ATOMIC;
-
-		xprt_set_connected(xprt);
-
-		/* Reset to new socket */
-		transport->sock = sock;
-		transport->inet = sk;
-
-		write_unlock_bh(&sk->sk_callback_lock);
-	}
-	xs_udp_do_set_buffer_size(xprt);
-	status = 0;
-out:
-	xprt_wake_pending_tasks(xprt, status);
-	xprt_clear_connecting(xprt);
 }
 
 /*
@@ -1272,93 +1215,6 @@ static void xs_tcp_reuse_connection(stru
  */
 static void xs_tcp_connect_worker(struct work_struct *work)
 {
-<<<<<<< HEAD/net/sunrpc/xprtsock.c
-	struct rpc_xprt *xprt =
-		container_of(work, struct rpc_xprt, connect_worker.work);
-	struct socket *sock = xprt->sock;
-=======
-	struct sock_xprt *transport = (struct sock_xprt *)args;
-	struct rpc_xprt *xprt = &transport->xprt;
-	struct socket *sock = transport->sock;
->>>>>>> /net/sunrpc/xprtsock.c
-	int err, status = -EIO;
-
-	if (xprt->shutdown || !xprt_bound(xprt))
-		goto out;
-
-	if (!sock) {
-		/* start from scratch */
-		if ((err = sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock)) < 0) {
-			dprintk("RPC:      can't create TCP transport socket (%d).\n", -err);
-			goto out;
-		}
-
-		if (xprt->resvport && xs_bindresvport(transport, sock) < 0) {
-			sock_release(sock);
-			goto out;
-		}
-	} else
-		/* "close" the socket, preserving the local port */
-		xs_tcp_reuse_connection(xprt);
-
-	dprintk("RPC:      worker connecting xprt %p to address: %s\n",
-			xprt, xprt->address_strings[RPC_DISPLAY_ALL]);
-
-	if (!transport->inet) {
-		struct sock *sk = sock->sk;
-
-		write_lock_bh(&sk->sk_callback_lock);
-
-		sk->sk_user_data = xprt;
-		transport->old_data_ready = sk->sk_data_ready;
-		transport->old_state_change = sk->sk_state_change;
-		transport->old_write_space = sk->sk_write_space;
-		sk->sk_data_ready = xs_tcp_data_ready;
-		sk->sk_state_change = xs_tcp_state_change;
-		sk->sk_write_space = xs_tcp_write_space;
-		sk->sk_allocation = GFP_ATOMIC;
-
-		/* socket options */
-		sk->sk_userlocks |= SOCK_BINDPORT_LOCK;
-		sock_reset_flag(sk, SOCK_LINGER);
-		tcp_sk(sk)->linger2 = 0;
-		tcp_sk(sk)->nonagle |= TCP_NAGLE_OFF;
-
-		xprt_clear_connected(xprt);
-
-		/* Reset to new socket */
-		transport->sock = sock;
-		transport->inet = sk;
-
-		write_unlock_bh(&sk->sk_callback_lock);
-	}
-
-	/* Tell the socket layer to start connecting... */
-	xprt->stat.connect_count++;
-	xprt->stat.connect_start = jiffies;
-	status = kernel_connect(sock, (struct sockaddr *) &xprt->addr,
-			xprt->addrlen, O_NONBLOCK);
-	dprintk("RPC: %p  connect status %d connected %d sock state %d\n",
-			xprt, -status, xprt_connected(xprt), sock->sk->sk_state);
-	if (status < 0) {
-		switch (status) {
-			case -EINPROGRESS:
-			case -EALREADY:
-				goto out_clear;
-			case -ECONNREFUSED:
-			case -ECONNRESET:
-				/* retry with existing socket, after a delay */
-				break;
-			default:
-				/* get rid of existing socket, and retry */
-				xs_close(xprt);
-				break;
-		}
-	}
-out:
-	xprt_wake_pending_tasks(xprt, status);
-out_clear:
-	xprt_clear_connecting(xprt);
 }
 
 /**
@@ -1376,32 +1232,6 @@ out_clear:
  */
 static void xs_connect(struct rpc_task *task)
 {
-	struct rpc_xprt *xprt = task->tk_xprt;
-	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
-
-	if (xprt_test_and_set_connecting(xprt))
-		return;
-
-	if (transport->sock != NULL) {
-		dprintk("RPC:      xs_connect delayed xprt %p for %lu seconds\n",
-				xprt, xprt->reestablish_timeout / HZ);
-		schedule_delayed_work(&transport->connect_worker,
-					xprt->reestablish_timeout);
-		xprt->reestablish_timeout <<= 1;
-		if (xprt->reestablish_timeout > XS_TCP_MAX_REEST_TO)
-			xprt->reestablish_timeout = XS_TCP_MAX_REEST_TO;
-	} else {
-		dprintk("RPC:      xs_connect scheduled xprt %p\n", xprt);
-<<<<<<< HEAD/net/sunrpc/xprtsock.c
-		schedule_delayed_work(&xprt->connect_worker, 0);
-=======
-		schedule_work(&transport->connect_worker);
->>>>>>> /net/sunrpc/xprtsock.c
-
-		/* flush_scheduled_work can sleep... */
-		if (!RPC_IS_ASYNC(task))
-			flush_scheduled_work();
-	}
 }
 
 /**
@@ -1525,44 +1355,6 @@ static struct rpc_xprt *xs_setup_xprt(st
  */
 struct rpc_xprt *xs_setup_udp(struct sockaddr *addr, size_t addrlen, struct rpc_timeout *to)
 {
-	struct rpc_xprt *xprt;
-	struct sock_xprt *transport;
-
-	xprt = xs_setup_xprt(addr, addrlen, xprt_udp_slot_table_entries);
-	if (IS_ERR(xprt))
-		return xprt;
-	transport = container_of(xprt, struct sock_xprt, xprt);
-
-	if (ntohs(((struct sockaddr_in *)addr)->sin_port) != 0)
-		xprt_set_bound(xprt);
-
-	xprt->prot = IPPROTO_UDP;
-	xprt->tsh_size = 0;
-	/* XXX: header size can vary due to auth type, IPv6, etc. */
-	xprt->max_payload = (1U << 16) - (MAX_HEADER << 3);
-
-<<<<<<< HEAD/net/sunrpc/xprtsock.c
-	INIT_DELAYED_WORK(&xprt->connect_worker, xs_udp_connect_worker);
-=======
-	INIT_WORK(&transport->connect_worker, xs_udp_connect_worker, transport);
->>>>>>> /net/sunrpc/xprtsock.c
-	xprt->bind_timeout = XS_BIND_TO;
-	xprt->connect_timeout = XS_UDP_CONN_TO;
-	xprt->reestablish_timeout = XS_UDP_REEST_TO;
-	xprt->idle_timeout = XS_IDLE_DISC_TO;
-
-	xprt->ops = &xs_udp_ops;
-
-	if (to)
-		xprt->timeout = *to;
-	else
-		xprt_set_timeout(&xprt->timeout, 5, 5 * HZ);
-
-	xs_format_peer_addresses(xprt);
-	dprintk("RPC:      set up transport to address %s\n",
-			xprt->address_strings[RPC_DISPLAY_ALL]);
-
-	return xprt;
 }
 
 /**
@@ -1574,43 +1366,6 @@ struct rpc_xprt *xs_setup_udp(struct soc
  */
 struct rpc_xprt *xs_setup_tcp(struct sockaddr *addr, size_t addrlen, struct rpc_timeout *to)
 {
-	struct rpc_xprt *xprt;
-	struct sock_xprt *transport;
-
-	xprt = xs_setup_xprt(addr, addrlen, xprt_tcp_slot_table_entries);
-	if (IS_ERR(xprt))
-		return xprt;
-	transport = container_of(xprt, struct sock_xprt, xprt);
-
-	if (ntohs(((struct sockaddr_in *)addr)->sin_port) != 0)
-		xprt_set_bound(xprt);
-
-	xprt->prot = IPPROTO_TCP;
-	xprt->tsh_size = sizeof(rpc_fraghdr) / sizeof(u32);
-	xprt->max_payload = RPC_MAX_FRAGMENT_SIZE;
-
-<<<<<<< HEAD/net/sunrpc/xprtsock.c
-	INIT_DELAYED_WORK(&xprt->connect_worker, xs_tcp_connect_worker);
-=======
-	INIT_WORK(&transport->connect_worker, xs_tcp_connect_worker, transport);
->>>>>>> /net/sunrpc/xprtsock.c
-	xprt->bind_timeout = XS_BIND_TO;
-	xprt->connect_timeout = XS_TCP_CONN_TO;
-	xprt->reestablish_timeout = XS_TCP_INIT_REEST_TO;
-	xprt->idle_timeout = XS_IDLE_DISC_TO;
-
-	xprt->ops = &xs_tcp_ops;
-
-	if (to)
-		xprt->timeout = *to;
-	else
-		xprt_set_timeout(&xprt->timeout, 2, 60 * HZ);
-
-	xs_format_peer_addresses(xprt);
-	dprintk("RPC:      set up transport to address %s\n",
-			xprt->address_strings[RPC_DISPLAY_ALL]);
-
-	return xprt;
 }
 
 /**
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
add-bottom_half.h.patch
drm-sis-linkage-fix.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
git-alsa-arm-fix.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-dvb.patch
git-dvb-fixup.patch
git-gfs2-nmw.patch
git-ia64.patch
git-ieee1394-fixup.patch
git-input.patch
git-input-fixup.patch
git-input-vs-git-alsa.patch
kbuild-fix-rr-is-now-default.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card-tidy.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-mtd-ssfdc-build-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-fixup.patch
libphy-dont-do-that.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-net.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
git-nfs-fixup.patch
pci-fix-multiple-problems-with-via-hardware.patch
fix-gregkh-pci-pci-enable-disable-device-is-nestable.patch
git-s390.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
nokia-e70-is-an-unusual-device.patch
pre-x86_64-mm-i386-reloc-abssym.patch
post-x86_64-mm-i386-reloc-abssym.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
touchkit-ps-2-touchscreen-driver.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token-tidy.patch
balance_pdgat-cleanup.patch
leak-tracking-for-kmalloc_node-fix.patch
add-numa-node-information-to-struct-device-tidy.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
slab-deprecate-kmem_cache-t.patch
mm-make-compound-page-destructor-handling-explicit-tidy.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
add-include-linux-freezerh-and-move-definitions-from-ueagle-fix.patch
add-include-linux-freezerh-and-move-definitions-from-ucb1400_ts-fix.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
convert-pm_sem-to-a-mutex-fix.patch
cciss-set-sector_size-to-2048-for-performance-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
probe_kernel_address-needs-to-do-set_fs.patch
slab-use-probe_kernel_address.patch
exar-quad-port-serial-fix.patch
vfs_getattr-remove-dead-code.patch
ext3-uninline-large-functions.patch
ext4-uninline-large-functions.patch
sleep-profiling-fixes.patch
sleep-profiling-fix.patch
debug-workqueue-locking-sanity-fix.patch
pcengines-wrap-led-support-fix.patch
driver-base-memoryc-remove-warnings-of.patch
remove-kernel-syscalls-x86_64-fix.patch
protect-ext2-ioctl-modifying-append_only-immutable-etc-with-i_mutex.patch
remove-hash_highmem.patch
elf-fix-kcore-note-size-calculation-fix.patch
reiserfs-add-missing-d-cache-flushing-tweak.patch
up-smp_call_function_single-should-disable-interrupts.patch
up-smp_call_function_single-should-disable-interrupts-fix.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use-vs-gregkh-driver-cpu-topology-consider-sysfs_create_group-return-value.patch
add-return-value-checking-of-get_user-in-fix.patch
handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set-tidy.patch
dz-fixes-to-make-it-work-fix.patch
ext4-balloc-fix-_with_rsv-freeze-fix.patch
ide_scsi-allow-it-to-be-used-for-non-cd-only-fix.patch
make-8250_pnp-serial-driver-work-after-tidy.patch
gcc-4-1-0-is-bust.patch
cleanup-include-asm-generic-atomich-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix-2.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

