Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3570C304972
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 01:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993178; cv=none; b=f4VAHDyVE3Ids+LCbFiBpmBuBhG8LXnKaSYcgTsbrhkB/fnF5ePTwDevW6A8H26jZEMks5QjXJajWFfUan+5o5cNisGbqz3/gBiA9RmJwPaH6ULtY4QOVgewNxBhHFf6NE+btQDmCipyiQueJDIuC1FvBgVPXFVIYX0JYyLijoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993178; c=relaxed/simple;
	bh=dol0x5w6mgVeoegyhjaIa8Ko2/OgnVyp94wZeY5NeXc=;
	h=Date:To:From:Subject:Message-Id; b=Icj+q4At/QcA6c2V088QNmCFpT/+w4wpBmaCorkfLz/VJqnEqtwL3qhcafza8rhueHY9QWT2qT+7V5iqBnzt8ZUG4KewIo0vR+BcZXR1wIQWmg0UZcSWk9vO37V0uWhGw5MsOpRjFjw/s+4srxOhSmck7+/xlQ/sXBx1h88wUII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vdPlaJ3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdPlaJ3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3C21F000E9;
	Tue, 14 Jul 2026 01:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783993176;
	bh=7OHv+ZZbFsbg3WPd9v+8+T78ffeRHaugb6LonqEXSxg=;
	h=Date:To:From:Subject;
	b=vdPlaJ3O9GmUiCXcrsdtlvJwDnh74z8F406CaQVW91Y8G/svrAqxffcUaOtGcPfox
	 3057yTTDUwL5+AnS4l+W2luwIx/lZ30DKQ8FJzre2nL8M7cskDIpQog1BAdTYf3oCk
	 MK67drolVTBH9XBoP1swOc5I88UJQET+ZxbM0Pcc=
Date: Mon, 13 Jul 2026 18:39:35 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test.patch added to mm-new branch
Message-Id: <20260714013935.EF3C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/dax: add dax/kmem hotplug sysfs regression test
has been added to the -mm mm-new branch.  Its filename is
     selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: selftests/dax: add dax/kmem hotplug sysfs regression test
Date: Sun, 12 Jul 2026 11:45:04 -0400

Add a kselftest for the dax/kmem whole-device "state" sysfs attribute
(/sys/bus/dax/devices/daxX.Y/state), which transitions a kmem-backed
dax device between "unplugged", "online" and "online_movable".

The kselftest also includes a test to demonstrate the force-unbind
does not deadlock - but this is destructive (the dax device can never
be rebound), so it only runs when DAX_KMEM_TEST_UNBIND=1 is set.

Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
out of scope for an in-tree selftest.  As the test mutates a device's
memory, the operator opts in by naming it in DAX_KMEM_TEST_DEV (or
"auto" to pick the first kmem-bound device); it SKIPs when unset, when
no device is present, or when the memory cannot be freed to a baseline.

When a device is available it validates the interface contract:
  - online / online_movable actually add memory (MemTotal grows),
  - online is idempotent,
  - switching between online types without unplug is rejected,
  - unplug removes memory and the reported state is "unplugged"
  - invalid input is rejected,
  - unplug and unbind tolerate blocks toggled out-of-band through the
    per-block memoryX/state interface.

One specific regression test:
    online -> unplug -> online_movable -> unplug

Re-online must re-reserve per-range resources so subsequent unplug
actually offlines and removes instead of silently reporting success
while the memory stays online.

Link: https://lore.kernel.org/20260712154505.3564379-11-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dan Williams <djbw@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                |    1 
 tools/testing/selftests/dax/Makefile            |    6 
 tools/testing/selftests/dax/config              |    4 
 tools/testing/selftests/dax/dax-kmem-hotplug.sh |  317 ++++++++++++++
 tools/testing/selftests/dax/settings            |    1 
 5 files changed, 329 insertions(+)

diff --git a/tools/testing/selftests/dax/config a/tools/testing/selftests/dax/config
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/dax/config
@@ -0,0 +1,4 @@
+CONFIG_DEV_DAX=m
+CONFIG_DEV_DAX_KMEM=m
+CONFIG_MEMORY_HOTPLUG=y
+CONFIG_MEMORY_HOTREMOVE=y
diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh a/tools/testing/selftests/dax/dax-kmem-hotplug.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/dax/dax-kmem-hotplug.sh
@@ -0,0 +1,317 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Exercise the dax/kmem "state" sysfs attribute:
+#   /sys/bus/dax/devices/daxX.Y/state  ->  unplugged | online | online_kernel | online_movable
+#
+# The test needs a dax device already bound to the kmem driver.
+#
+# This test mutates a device's memory: online/offline cycles migrate any
+# in-use pages, and the optional unbind subtest wedges the device until
+# reboot. The tester must identify the target device and opt into the
+# destructive unbind tests.
+#
+#   DAX_KMEM_TEST_DEV=daxX.Y   test this specific device
+#   DAX_KMEM_TEST_DEV=auto     auto-discover the first kmem-bound dax device
+#                              (best-effort: it may be a device in use!)
+#   DAX_KMEM_TEST_UNBIND=1     also run the destructive unbind-while-online test
+#
+# If DAX_KMEM_TEST_DEV is unset the whole test SKIPs.
+#
+# A dax device can be provisioned with the memmap= boot param, e.g.:
+#   memmap=2G!4G
+#
+# then, in the booted system:
+#
+#   ndctl create-namespace -m devdax -e namespace0.0 -f
+#   daxctl reconfigure-device -N -m system-ram dax0.0   # bind kmem
+#   DAX_KMEM_TEST_DEV=auto ./dax-kmem-hotplug.sh
+
+# shellcheck disable=SC1091
+DIR="$(dirname "$(readlink -f "$0")")"
+. "$DIR"/../kselftest/ktap_helpers.sh
+
+DAX_BASE=/sys/bus/dax/devices
+MEM_BASE=/sys/devices/system/memory
+
+memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
+get_state() { cat "$HP" 2>/dev/null; }
+# set_state STATE -- write a state to the state attribute; returns the
+# write's exit status (0 = accepted by the kernel)
+set_state() { echo "$1" > "$HP" 2>/dev/null; }
+
+is_kmem_dax() {
+	local drv
+	[ -e "$DAX_BASE/$1/state" ] || return 1
+	drv=$(readlink "$DAX_BASE/$1/driver" 2>/dev/null)
+	[ "$(basename "${drv:-}")" = kmem ]
+}
+
+find_kmem_dax() {
+	local d
+	for d in "$DAX_BASE"/dax*; do
+		is_kmem_dax "$(basename "$d")" || continue
+		basename "$d"
+		return 0
+	done
+	return 1
+}
+
+# find_device_blocks -- print every memoryN block backing this dax device.
+# The blocks are derived from the device's own range(s) in /proc/iomem (the
+# reserved resource is named after the device), so we act on *its* blocks
+# rather than guessing by NUMA node - the target node may also hold unrelated
+# (and non-offlineable) memory.
+find_device_blocks() {
+	local bs
+	bs=$(cat "$MEM_BASE/block_size_bytes" 2>/dev/null)	# hex, no leading 0x
+	[ -n "$bs" ] || return 1
+	grep -E " : ${DAX}\$" /proc/iomem | while read -r line; do
+		local range s e i
+		range=${line%% :*}; range=${range// /}
+		s=${range%-*}; e=${range#*-}
+		for (( i = 0x$s / 0x$bs; i <= 0x$e / 0x$bs; i++ )); do
+			echo "memory$i"
+		done
+	done
+}
+
+# find_device_block -- print the first online block backing this dax device.
+find_device_block() {
+	local b
+	for b in $(find_device_blocks); do
+		[ -f "$MEM_BASE/$b/state" ] || continue
+		[ "$(cat "$MEM_BASE/$b/state")" = online ] || continue
+		echo "$b"
+		return 0
+	done
+	return 1
+}
+
+ktap_print_header
+
+if [ "$UID" != 0 ]; then
+	ktap_skip_all "must be run as root"
+	exit "$KSFT_SKIP"
+fi
+
+# Device selection is opt-in - see the header for why.
+DEV_SEL=${DAX_KMEM_TEST_DEV:-}
+if [ -z "$DEV_SEL" ]; then
+	ktap_skip_all "set DAX_KMEM_TEST_DEV=<daxX.Y|auto> to opt in (mutates device memory)"
+	exit "$KSFT_SKIP"
+fi
+if [ "$DEV_SEL" = auto ]; then
+	DAX=$(find_kmem_dax)
+else
+	DAX=$DEV_SEL
+fi
+if [ -z "$DAX" ] || ! is_kmem_dax "$DAX"; then
+	ktap_skip_all "no kmem-bound dax device with a state attribute (${DEV_SEL})"
+	exit "$KSFT_SKIP"
+fi
+HP=$DAX_BASE/$DAX/state
+ORIG=$(get_state)
+
+# A failure to reach the baseline is environmental (memory in use), not an
+# interface failure, so skip rather than fail.
+set_state unplugged; rc=$?
+if [ "$rc" != 0 ] || [ "$(get_state)" != unplugged ]; then
+	ktap_skip_all "$DAX: cannot reach 'unplugged' baseline (memory in use?)"
+	[ -n "$ORIG" ] && set_state "$ORIG"
+	exit "$KSFT_SKIP"
+fi
+mt_unplugged=$(memtotal_kb)
+
+DRV=/sys/bus/dax/drivers/kmem
+AOB=$MEM_BASE/auto_online_blocks
+
+ktap_print_msg "using $DAX (initial state was: $ORIG)"
+ktap_set_plan 10
+
+# A public (N_MEMORY) kmem node onlined into a kernel zone (online/online_kernel)
+# collects unmovable allocations and can then never be offlined, which would
+# wedge the device for the rest of this test.  So this test only ever
+# successfully onlines online_movable, the one mode that is reliably unpluggable.
+
+set_state online_movable; rc=$?
+mt_online=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online_movable: state=online_movable, MemTotal $mt_unplugged -> $mt_online kB"
+else
+	ktap_test_fail "online_movable: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
+fi
+
+set_state online_movable; rc=$?
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ]; then
+	ktap_test_pass "online_movable idempotent"
+else
+	ktap_test_fail "online_movable idempotent: rc=$rc state=$(get_state)"
+fi
+
+# A different online type is rejected without an intervening unplug.  The write
+# is refused before any hotplug, so this never actually onlines a kernel zone.
+set_state online_kernel; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = online_movable ]; then
+	ktap_test_pass "reject online_kernel without intervening unplug (no kernel-zone online)"
+else
+	ktap_test_fail "online_movable->online_kernel not rejected: rc=$rc state=$(get_state)"
+fi
+
+set_state unplugged; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
+	ktap_test_pass "unplug from online_movable: MemTotal $mt_online -> $mt kB"
+else
+	ktap_test_fail "unplug from online_movable: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
+fi
+
+before=$(get_state)
+set_state bogus_state; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
+	ktap_test_pass "reject invalid state string"
+else
+	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
+fi
+
+# An online_movable -> unplug cycle must re-acquire the per-range resources on
+# each online and release them on each unplug.  Assert every iteration grows
+# MemTotal past the baseline and returns exactly to it; memory left online after
+# unplug (off > baseline) is a partial-free failure.
+set_state unplugged
+cycle_ok=1; fail_i=0; on=0; off=0
+for i in 1 2 3; do
+	if ! set_state online_movable; then cycle_ok=0; fail_i=$i; break; fi
+	on=$(memtotal_kb)
+	if ! set_state unplugged; then cycle_ok=0; fail_i=$i; break; fi
+	off=$(memtotal_kb)
+	# online must grow past baseline, and unplug must return to it - a
+	# partial free (memory left online) is a failure, not just off == on.
+	if [ "$on" -le "$mt_unplugged" ] || [ "$off" -gt "$mt_unplugged" ]; then
+		cycle_ok=0; fail_i=$i; break
+	fi
+done
+if [ "$cycle_ok" = 1 ]; then
+	ktap_test_pass "online_movable/unplug cycle re-acquires resources (3x: added and freed each time)"
+else
+	ktap_test_fail "online_movable/unplug cycle regressed at iteration $fail_i (on=$on off=$off baseline=$mt_unplugged)"
+fi
+
+# Desync: toggle a block through the legacy per-block memoryN/state interface
+# behind the driver's back, then unplug the whole device via daxX.Y/state.
+#
+# The driver only updates daxX.Y/state on its own writes, so it still reports
+# online_movable while a block underneath is already offline.
+#
+# Whole-device unplug must still succeed (within reason, an actor changing a
+# device from online_movable to online_kernel can no longer guarantee unplug).
+# At the very least, an already-offline block should not produce an error.
+set_state unplugged
+set_state online_movable
+blk=$(find_device_block)
+if [ -n "$blk" ] && echo offline > "$MEM_BASE/$blk/state" 2>/dev/null; then
+	# daxX.Y/state is now stale (still online_movable); unplug the device.
+	set_state unplugged; rc=$?
+	mt=$(memtotal_kb)
+	if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -le "$mt_unplugged" ]; then
+		ktap_test_pass "unplug tolerates a block pre-offlined via memoryN/state ($blk)"
+	else
+		ktap_test_fail "desync unplug: rc=$rc state=$(get_state) MemTotal=$mt baseline=$mt_unplugged"
+	fi
+else
+	set_state unplugged 2>/dev/null
+	ktap_test_skip "could not locate a device block to offline for desync test"
+fi
+
+# change system default online policy while the device is unbound, and show
+# the new system default policy is utilized across bindings.
+set_state unplugged
+if [ -w "$AOB" ] && [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
+	orig_aob=$(cat "$AOB")
+	echo "$DAX" > "$DRV/unbind" 2>/dev/null
+	echo offline > "$AOB" 2>/dev/null
+	echo "$DAX" > "$DRV/bind" 2>/dev/null
+	sleep 1
+	st=$(get_state)
+	echo "$orig_aob" > "$AOB" 2>/dev/null		# restore system policy
+	if [ "$st" = offline ]; then
+		ktap_test_pass "online policy resolved at bind: auto_online_blocks=offline -> state=offline"
+	else
+		ktap_test_fail "bind-time policy not honored: state=$st (expected offline)"
+	fi
+	set_state unplugged 2>/dev/null
+else
+	ktap_test_skip "auto_online_blocks or driver bind/unbind not writable"
+fi
+
+# Blocks offlined out-of-band (via memoryN/state) leave daxX.Y/state stale
+# (still online_movable) while every block is actually offline.  A driver unbind
+# must still hot-remove the offline memory and free its resources rather than
+# trust the stale state and leak until reboot.  Unbind uses remove_memory(),
+# which never offlines, so removing already-offline blocks is non-destructive and
+# the device rebinds cleanly afterwards.
+if [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
+	set_state unplugged
+	set_state online_movable
+	offl_ok=1
+	for b in $(find_device_blocks); do
+		[ -f "$MEM_BASE/$b/state" ] || continue
+		[ "$(cat "$MEM_BASE/$b/state")" = online ] || continue
+		echo offline > "$MEM_BASE/$b/state" 2>/dev/null || offl_ok=0
+	done
+	# daxX.Y/state is now stale (still online_movable) while all blocks are
+	# offline; the unbind must hot-remove them anyway.
+	if [ "$offl_ok" = 1 ] && [ "$(get_state)" = online_movable ]; then
+		echo "$DAX" > "$DRV/unbind" 2>/dev/null
+		mt_after=$(memtotal_kb)
+		leaked=$(grep -cE " : ${DAX}\$" /proc/iomem)	# before rebind
+		echo "$DAX" > "$DRV/bind" 2>/dev/null		# restore for later steps
+		sleep 1
+		if [ "$mt_after" -le "$mt_unplugged" ] && [ "$leaked" = 0 ]; then
+			ktap_test_pass "unbind with stale online state hot-removes offlined blocks (no leak)"
+		else
+			ktap_test_fail "desync unbind leaked: MemTotal=$mt_after baseline=$mt_unplugged iomem_left=$leaked"
+		fi
+		set_state unplugged 2>/dev/null
+	else
+		ktap_test_skip "could not offline all device blocks for desync-unbind test"
+	fi
+else
+	ktap_test_skip "driver bind/unbind not writable for desync-unbind test"
+fi
+
+[ -n "$ORIG" ] && set_state "$ORIG"
+
+# DESTRUCTIVE and opt-in only (DAX_KMEM_TEST_UNBIND=1):
+#
+# unbinding the driver while memory is online causes the resources to leak - but
+# the unbind should not deadlock.  Instead the driver leaks it with a warning.
+
+# This leaves the memory online and the device unbound until reboot, so it runs
+# last and only when explicitly requested.  online_movable only: this test
+# never onlines a public node into a kernel zone.
+
+if [ "${DAX_KMEM_TEST_UNBIND:-}" = 1 ] && [ -w "$DRV/unbind" ]; then
+	set_state unplugged; set_state online_movable
+fi
+if [ "${DAX_KMEM_TEST_UNBIND:-}" = 1 ] && [ "$(get_state)" = online_movable ] &&
+   [ -w "$DRV/unbind" ]; then
+	mt_on=$(memtotal_kb)
+	dmesg -C 2>/dev/null
+	echo "$DAX" > "$DRV/unbind" 2>/dev/null
+	mt_after=$(memtotal_kb)
+	# The leaked "System RAM (kmem)" regions stay in the iomem tree; reading
+	# their names dereferences res_name, which a buggy unbind already freed.
+	# Walk /proc/iomem to provoke that use-after-free (caught by KASAN).
+	cat /proc/iomem > /dev/null 2>&1
+	splat=$(dmesg 2>/dev/null | grep -ciE "KASAN|BUG:|use-after-free|general protection|Oops|refcount_t")
+	if [ "$splat" = 0 ] && [ "$mt_after" -ge "$mt_on" ]; then
+		ktap_test_pass "unbind while online: memory left online, no UAF/oops (MemTotal $mt_on -> $mt_after kB)"
+	else
+		ktap_test_fail "unbind while online regressed: splat=$splat MemTotal $mt_on -> $mt_after kB"
+	fi
+else
+	ktap_test_skip "destructive unbind-while-online test (set DAX_KMEM_TEST_UNBIND=1)"
+fi
+
+ktap_finished
diff --git a/tools/testing/selftests/dax/Makefile a/tools/testing/selftests/dax/Makefile
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/dax/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+all:
+
+TEST_PROGS := dax-kmem-hotplug.sh
+
+include ../lib.mk
diff --git a/tools/testing/selftests/dax/settings a/tools/testing/selftests/dax/settings
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/dax/settings
@@ -0,0 +1 @@
+timeout=90
--- a/tools/testing/selftests/Makefile~selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test
+++ a/tools/testing/selftests/Makefile
@@ -15,6 +15,7 @@ TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
 TARGETS += damon
+TARGETS += dax
 TARGETS += devices/error_logs
 TARGETS += devices/probe
 TARGETS += dmabuf-heaps
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch
mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch
mm-memory-add-memory_block_aligned_range-helper.patch
mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch
mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch
mm-memory_hotplug-export-mhp_get_default_online_type.patch
mm-memory_hotplug-add-__add_memory_driver_managed-with-online_type-arg.patch
mm-memory_hotplug-add-offline_and_remove_memory_ranges.patch
dax-kmem-resolve-default-online-type-at-probe-time.patch
dax-kmem-extract-hotplug-hotremove-helper-functions.patch
dax-kmem-add-sysfs-interface-for-atomic-whole-device-hotplug.patch
selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test.patch

