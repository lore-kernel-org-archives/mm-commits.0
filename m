From: akpm@osdl.org
Subject: - uml-use-get_random_bytes-after-random-pool-is-seeded.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:13 -0800
Message-ID: <200612072300.kB7N0DJG029619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51195 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163711AbWLGXAQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: use get_random_bytes() after random pool is seeded
has been removed from the -mm tree.  Its filename was
     uml-use-get_random_bytes-after-random-pool-is-seeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use get_random_bytes() after random pool is seeded
From: Jeff Dike <jdike@addtoit.com>

When the UML network driver generates random MACs for its devices, it was
possible for a number of UMLs to get the same MACs because the ethernet
initialization was done before the random pool was properly seeded.

This patch moves the initialization later so that it gets better randomness.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/daemon_kern.c            |    2 +-
 arch/um/drivers/mcast_kern.c             |    2 +-
 arch/um/drivers/pcap_kern.c              |    2 +-
 arch/um/drivers/slip_kern.c              |    2 +-
 arch/um/drivers/slirp_kern.c             |    2 +-
 arch/um/os-Linux/drivers/ethertap_kern.c |    2 +-
 arch/um/os-Linux/drivers/tuntap_kern.c   |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/um/drivers/daemon_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded arch/um/drivers/daemon_kern.c
--- a/arch/um/drivers/daemon_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded
+++ a/arch/um/drivers/daemon_kern.c
@@ -98,4 +98,4 @@ static int register_daemon(void)
 	return 0;
 }
 
-__initcall(register_daemon);
+late_initcall(register_daemon);
diff -puN arch/um/drivers/mcast_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded arch/um/drivers/mcast_kern.c
--- a/arch/um/drivers/mcast_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded
+++ a/arch/um/drivers/mcast_kern.c
@@ -127,4 +127,4 @@ static int register_mcast(void)
 	return 0;
 }
 
-__initcall(register_mcast);
+late_initcall(register_mcast);
diff -puN arch/um/drivers/pcap_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded arch/um/drivers/pcap_kern.c
--- a/arch/um/drivers/pcap_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded
+++ a/arch/um/drivers/pcap_kern.c
@@ -109,4 +109,4 @@ static int register_pcap(void)
 	return 0;
 }
 
-__initcall(register_pcap);
+late_initcall(register_pcap);
diff -puN arch/um/drivers/slip_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded arch/um/drivers/slip_kern.c
--- a/arch/um/drivers/slip_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded
+++ a/arch/um/drivers/slip_kern.c
@@ -95,4 +95,4 @@ static int register_slip(void)
 	return 0;
 }
 
-__initcall(register_slip);
+late_initcall(register_slip);
diff -puN arch/um/drivers/slirp_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded arch/um/drivers/slirp_kern.c
--- a/arch/um/drivers/slirp_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded
+++ a/arch/um/drivers/slirp_kern.c
@@ -119,4 +119,4 @@ static int register_slirp(void)
 	return 0;
 }
 
-__initcall(register_slirp);
+late_initcall(register_slirp);
diff -puN arch/um/os-Linux/drivers/ethertap_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded arch/um/os-Linux/drivers/ethertap_kern.c
--- a/arch/um/os-Linux/drivers/ethertap_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded
+++ a/arch/um/os-Linux/drivers/ethertap_kern.c
@@ -105,4 +105,4 @@ static int register_ethertap(void)
 	return 0;
 }
 
-__initcall(register_ethertap);
+late_initcall(register_ethertap);
diff -puN arch/um/os-Linux/drivers/tuntap_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded arch/um/os-Linux/drivers/tuntap_kern.c
--- a/arch/um/os-Linux/drivers/tuntap_kern.c~uml-use-get_random_bytes-after-random-pool-is-seeded
+++ a/arch/um/os-Linux/drivers/tuntap_kern.c
@@ -90,4 +90,4 @@ static int register_tuntap(void)
 	return 0;
 }
 
-__initcall(register_tuntap);
+late_initcall(register_tuntap);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-fix-prototypes.patch
tty-signal-tty-locking.patch
uml-add-generic-bug-support.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix.patch
tty-switch-to-ktermios-uml-fix.patch

