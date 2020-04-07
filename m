From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 063/166] drivers/base/memory: rename
 MMOP_ONLINE_KEEP to MMOP_ONLINE
Date: Mon, 06 Apr 2020 20:07:16 -0700
Message-ID: <20200407030716.UybcbUbHJ%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:20 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, torvalds@linux-foundation.org, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com

From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: rename MMOP_ONLINE_KEEP to MMOP_ONLINE

Patch series "mm/memory_hotplug: allow to specify a default online_type", v3.

Distributions nowadays use udev rules ([1] [2]) to specify if and how to
online hotplugged memory.  The rules seem to get more complex with many
special cases.  Due to the various special cases,
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE cannot be used.  All memory hotplug
is handled via udev rules.

Every time we hotplug memory, the udev rule will come to the same
conclusion.  Especially Hyper-V (but also soon virtio-mem) add a lot of
memory in separate memory blocks and wait for memory to get onlined by
user space before continuing to add more memory blocks (to not add memory
faster than it is getting onlined).  This of course slows down the whole
memory hotplug process.

To make the job of distributions easier and to avoid udev rules that get
more and more complicated, let's extend the mechanism provided by
- /sys/devices/system/memory/auto_online_blocks
- "memhp_default_state=" on the kernel cmdline
to be able to specify also "online_movable" as well as "online_kernel"

=== Example /usr/libexec/config-memhotplug ===

#!/bin/bash

VIRT=`systemd-detect-virt --vm`
ARCH=`uname -p`

sense_virtio_mem() {
  if [ -d "/sys/bus/virtio/drivers/virtio_mem/" ]; then
    DEVICES=`find /sys/bus/virtio/drivers/virtio_mem/ -maxdepth 1 -type l | wc -l`
    if [ $DEVICES != "0" ]; then
        return 0
    fi
  fi
  return 1
}

if [ ! -e "/sys/devices/system/memory/auto_online_blocks" ]; then
  echo "Memory hotplug configuration support missing in the kernel"
  exit 1
fi

if grep "memhp_default_state=" /proc/cmdline > /dev/null; then
  echo "Memory hotplug configuration overridden in kernel cmdline (memhp_default_state=)"
  exit 1
fi

if [ $VIRT == "microsoft" ]; then
  echo "Detected Hyper-V on $ARCH"
  # Hyper-V wants all memory in ZONE_NORMAL
  ONLINE_TYPE="online_kernel"
elif sense_virtio_mem; then
  echo "Detected virtio-mem on $ARCH"
  # virtio-mem wants all memory in ZONE_NORMAL
  ONLINE_TYPE="online_kernel"
elif [ $ARCH == "s390x" ] || [ $ARCH == "s390" ]; then
  echo "Detected $ARCH"
  # standby memory should not be onlined automatically
  ONLINE_TYPE="offline"
elif [ $ARCH == "ppc64" ] || [ $ARCH == "ppc64le" ]; then
  echo "Detected" $ARCH
  # PPC64 onlines all hotplugged memory right from the kernel
  ONLINE_TYPE="offline"
elif [ $VIRT == "none" ]; then
  echo "Detected bare-metal on $ARCH"
  # Bare metal users expect hotplugged memory to be unpluggable. We assume
  # that ZONE imbalances on such enterpise servers cannot happen and is
  # properly documented
  ONLINE_TYPE="online_movable"
else
  # TODO: Hypervisors that want to unplug DIMMs and can guarantee that ZONE
  # imbalances won't happen
  echo "Detected $VIRT on $ARCH"
  # Usually, ballooning is used in virtual environments, so memory should go to
  # ZONE_NORMAL. However, sometimes "movable_node" is relevant.
  ONLINE_TYPE="online"
fi

echo "Selected online_type:" $ONLINE_TYPE

# Configure what to do with memory that will be hotplugged in the future
echo $ONLINE_TYPE 2>/dev/null > /sys/devices/system/memory/auto_online_blocks
if [ $? != "0" ]; then
  echo "Memory hotplug cannot be configured (e.g., old kernel or missing permissions)"
  # A backup udev rule should handle old kernels if necessary
  exit 1
fi

# Process all already pluggedd blocks (e.g., DIMMs, but also Hyper-V or virtio-mem)
if [ $ONLINE_TYPE != "offline" ]; then
  for MEMORY in /sys/devices/system/memory/memory*; do
    STATE=`cat $MEMORY/state`
    if [ $STATE == "offline" ]; then
        echo $ONLINE_TYPE > $MEMORY/state
    fi
  done
fi

=== Example /usr/lib/systemd/system/config-memhotplug.service ===

[Unit]
Description=Configure memory hotplug behavior
DefaultDependencies=no
Conflicts=shutdown.target
Before=sysinit.target shutdown.target
After=systemd-modules-load.service
ConditionPathExists=|/sys/devices/system/memory/auto_online_blocks

[Service]
ExecStart=/usr/libexec/config-memhotplug
Type=oneshot
TimeoutSec=0
RemainAfterExit=yes

[Install]
WantedBy=sysinit.target

=== Example modification to the 40-redhat.rules [2] ===

: diff --git a/40-redhat.rules b/40-redhat.rules-new
: index 2c690e5..168fd03 100644
: --- a/40-redhat.rules
: +++ b/40-redhat.rules-new
: @@ -6,6 +6,9 @@ SUBSYSTEM=="cpu", ACTION=="add", TEST=="online", ATTR{online}=="0", ATTR{online}
:  # Memory hotadd request
:  SUBSYSTEM!="memory", GOTO="memory_hotplug_end"
:  ACTION!="add", GOTO="memory_hotplug_end"
: +# memory hotplug behavior configured
: +PROGRAM=="grep online /sys/devices/system/memory/auto_online_blocks", GOTO="memory_hotplug_end"
: +
:  PROGRAM="/bin/uname -p", RESULT=="s390*", GOTO="memory_hotplug_end"
: 
:  ENV{.state}="online"

===

[1] https://github.com/lnykryn/systemd-rhel/pull/281
[2] https://github.com/lnykryn/systemd-rhel/blob/staging/rules/40-redhat.rules


This patch (of 8):

The name is misleading and it's not really clear what is "kept".  Let's
just name it like the online_type name we expose to user space ("online").

Add some documentation to the types.

Link: http://lkml.kernel.org/r/20200319131221.14044-1-david@redhat.com
Link: http://lkml.kernel.org/r/20200317104942.11178-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Yumei Huang <yuhuang@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    9 +++++----
 include/linux/memory_hotplug.h |    6 +++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-rename-mmop_online_keep-to-mmop_online
+++ a/drivers/base/memory.c
@@ -208,7 +208,7 @@ static int memory_subsys_online(struct d
 	 * attribute and need to set the online_type.
 	 */
 	if (mem->online_type < 0)
-		mem->online_type = MMOP_ONLINE_KEEP;
+		mem->online_type = MMOP_ONLINE;
 
 	ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
 
@@ -243,7 +243,7 @@ static ssize_t state_store(struct device
 	else if (sysfs_streq(buf, "online_movable"))
 		online_type = MMOP_ONLINE_MOVABLE;
 	else if (sysfs_streq(buf, "online"))
-		online_type = MMOP_ONLINE_KEEP;
+		online_type = MMOP_ONLINE;
 	else if (sysfs_streq(buf, "offline"))
 		online_type = MMOP_OFFLINE;
 	else {
@@ -254,7 +254,7 @@ static ssize_t state_store(struct device
 	switch (online_type) {
 	case MMOP_ONLINE_KERNEL:
 	case MMOP_ONLINE_MOVABLE:
-	case MMOP_ONLINE_KEEP:
+	case MMOP_ONLINE:
 		/* mem->online_type is protected by device_hotplug_lock */
 		mem->online_type = online_type;
 		ret = device_online(&mem->dev);
@@ -334,7 +334,8 @@ static ssize_t valid_zones_show(struct d
 	}
 
 	nid = mem->nid;
-	default_zone = zone_for_pfn_range(MMOP_ONLINE_KEEP, nid, start_pfn, nr_pages);
+	default_zone = zone_for_pfn_range(MMOP_ONLINE, nid, start_pfn,
+					  nr_pages);
 	strcat(buf, default_zone->name);
 
 	print_allowed_zone(buf, nid, start_pfn, nr_pages, MMOP_ONLINE_KERNEL,
--- a/include/linux/memory_hotplug.h~drivers-base-memory-rename-mmop_online_keep-to-mmop_online
+++ a/include/linux/memory_hotplug.h
@@ -47,9 +47,13 @@ enum {
 
 /* Types for control the zone type of onlined and offlined memory */
 enum {
+	/* Offline the memory. */
 	MMOP_OFFLINE = -1,
-	MMOP_ONLINE_KEEP,
+	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
+	MMOP_ONLINE,
+	/* Online the memory to ZONE_NORMAL. */
 	MMOP_ONLINE_KERNEL,
+	/* Online the memory to ZONE_MOVABLE. */
 	MMOP_ONLINE_MOVABLE,
 };
 
_
