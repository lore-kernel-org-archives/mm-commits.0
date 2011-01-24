From: akpm@linux-foundation.org
Subject: + rapidio-add-rapidio-documentation.patch added to -mm tree
Date: Mon, 24 Jan 2011 12:30:41 -0800
Message-ID: <201101242030.p0OKUglF008533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab1AXUb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 15:31:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, mporter@kernel.crashing.org, rdunlap@xenotime.net


The patch titled
     rapidio: add RapidIO documentation
has been added to the -mm tree.  Its filename is
     rapidio-add-rapidio-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add RapidIO documentation
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add RapidIO documentation files as it was discussed earlier (see thread
http://marc.info/?l=linux-kernel&m=129202338918062&w=2)

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/rapidio.txt |  173 ++++++++++++++++++++++++++++
 Documentation/rapidio/sysfs.txt   |   79 ++++++++++++
 2 files changed, 252 insertions(+)

diff -puN /dev/null Documentation/rapidio/rapidio.txt
--- /dev/null
+++ a/Documentation/rapidio/rapidio.txt
@@ -0,0 +1,173 @@
+                          The Linux RapidIO Subsystem
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The RapidIO standard is a packet-based fabric interconnect standard designed for
+use in embedded systems. Development of the RapidIO standard is directed by the
+RapidIO Trade Association (RTA). The current version of the RapidIO specification
+is publicly available for download from the RTA web-site [1].
+
+This document describes the basics of the Linux RapidIO subsystem and provides
+information on its major components.
+
+1 Overview
+----------
+
+Because the RapidIO subsystem follows the Linux device model it is integrated
+into the kernel similarly to other buses by defining RapidIO-specific device and
+bus types and registering them within the device model.
+
+The Linux RapidIO subsystem is architecture independent and therefore defines
+architecture-specific interfaces that provide support for common RapidIO
+subsystem operations.
+
+2. Core Components
+------------------
+
+A typical RapidIO network is a combination of endpoints and switches.
+Each of these components is represented in the subsystem by an associated data
+structure. The core logical components of the RapidIO subsystem are defined
+in include/linux/rio.h file.
+
+2.1 Master Port
+
+A master port (or mport) is a RapidIO interface controller that is local to the
+processor executing the Linux code. A master port generates and receives RapidIO
+packets (transactions). In the RapidIO subsystem each master port is represented
+by a rio_mport data structure. This structure contains master port specific
+resources such as mailboxes and doorbells. The rio_mport also includes a unique
+host device ID that is valid when a master port is configured as an enumerating
+host.
+
+RapidIO master ports are serviced by subsystem specific mport device drivers
+that provide functionality defined for this subsystem. To provide a hardware
+independent interface for RapidIO subsystem operations, rio_mport structure
+includes rio_ops data structure which contains pointers to hardware specific
+implementations of RapidIO functions.
+
+2.2 Device
+
+A RapidIO device is any endpoint (other than mport) or switch in the network.
+All devices are presented in the RapidIO subsystem by corresponding rio_dev data
+structure. Devices form one global device list and per-network device lists
+(depending on number of available mports and networks).
+
+2.3 Switch
+
+A RapidIO switch is a special class of device that routes packets between its
+ports towards their final destination. The packet destination port within a
+switch is defined by an internal routing table. A switch is presented in the
+RapidIO subsystem by rio_dev data structure expanded by additional rio_switch
+data structure, which contains switch specific information such as copy of the
+routing table and pointers to switch specific functions.
+
+The RapidIO subsystem defines the format and initialization method for subsystem
+specific switch drivers that are designed to provide hardware-specific
+implementation of common switch management routines.
+
+2.4 Network
+
+A RapidIO network is a combination of interconnected endpoint and switch devices.
+Each RapidIO network known to the system is represented by corresponding rio_net
+data structure. This structure includes lists of all devices and local master
+ports that form the same network. It also contains a pointer to the default
+master port that is used to communicate with devices within the network.
+
+3. Subsystem Initialization
+---------------------------
+
+In order to initialize the RapidIO subsystem, a platform must initialize and
+register at least one master port within the RapidIO network. To register mport
+within the subsystem controller driver initialization code calls function
+rio_register_mport() for each available master port. After all active master
+ports are registered with a RapidIO subsystem, the rio_init_mports() routine
+is called to perform enumeration and discovery.
+
+In the current PowerPC-based implementation a subsys_initcall() is specified to
+perform controller initialization and mport registration. At the end it directly
+calls rio_init_mports() to execute RapidIO enumeration and discovery.
+
+4. Enumeration and Discovery
+----------------------------
+
+When rio_init_mports() is called it scans a list of registered master ports and
+calls an enumeration or discovery routine depending on the configured role of a
+master port: host or agent.
+
+Enumeration is performed by a master port if it is configured as a host port by
+assigning a host device ID greater than or equal to zero. A host device ID is
+assigned to a master port through the kernel command line parameter "riohdid=",
+or can be configured in a platform-specific manner. If the host device ID for
+a specific master port is set to -1, the discovery process will be performed
+for it.
+
+The enumeration and discovery routines use RapidIO maintenance transactions
+to access the configuration space of devices.
+
+The enumeration process is implemented according to the enumeration algorithm
+outlined in the RapidIO Interconnect Specification: Annex I [1].
+
+The enumeration process traverses the network using a recursive depth-first
+algorithm. When a new device is found, the enumerator takes ownership of that
+device by writing into the Host Device ID Lock CSR. It does this to ensure that
+the enumerator has exclusive right to enumerate the device. If device ownership
+is successfully acquired, the enumerator allocates a new rio_dev structure and
+initializes it according to device capabilities.
+
+If the device is an endpoint, a unique device ID is assigned to it and its value
+is written into the device's Base Device ID CSR.
+
+If the device is a switch, the enumerator allocates an additional rio_switch
+structure to store switch specific information. Then the switch's vendor ID and
+device ID are queried against a table of known RapidIO switches. Each switch
+table entry contains a pointer to a switch-specific initialization routine that
+initializes pointers to the rest of switch specific operations, and performs
+hardware initialization if necessary. A RapidIO switch does not have a unique
+device ID; it relies on hopcount and routing for device ID of an attached
+endpoint if access to its configuration registers is required. If a switch (or
+chain of switches) does not have any endpoint (except enumerator) attached to
+it, a fake device ID will be assigned to configure a route to that switch.
+In the case of a chain of switches without endpoint, one fake device ID is used
+to configure a route through the entire chain and switches are differentiated by
+their hopcount value.
+
+For both endpoints and switches the enumerator writes a unique component tag
+into device's Component Tag CSR. That unique value is used by the error
+management notification mechanism to identify a device that is reporting an
+error management event.
+
+Enumeration beyond a switch is completed by iterating over each active egress
+port of that switch. For each active link, a route to a default device ID
+(0xFF for 8-bit systems and 0xFFFF for 16-bit systems) is temporarily written
+into the routing table. The algorithm recurs by calling itself with hopcount + 1
+and the default device ID in order to access the device on the active port.
+
+After the host has completed enumeration of the entire network it releases
+devices by clearing device ID locks (calls rio_clear_locks()). For each endpoint
+in the system, it sets the Master Enable bit in the Port General Control CSR
+to indicate that enumeration is completed and agents are allowed to execute
+passive discovery of the network.
+
+The discovery process is performed by agents and is similar to the enumeration
+process that is described above. However, the discovery process is performed
+without changes to the existing routing because agents only gather information
+about RapidIO network structure and are building an internal map of discovered
+devices. This way each Linux-based component of the RapidIO subsystem has
+a complete view of the network. The discovery process can be performed
+simultaneously by several agents. After initializing its RapidIO master port
+each agent waits for enumeration completion by the host for the configured wait
+time period. If this wait time period expires before enumeration is completed,
+an agent skips RapidIO discovery and continues with remaining kernel
+initialization.
+
+5. References
+-------------
+
+[1] RapidIO Trade Association. RapidIO Interconnect Specifications.
+    http://www.rapidio.org.
+[2] Rapidio TA. Technology Comparisons.
+    http://www.rapidio.org/education/technology_comparisons/
+[3] RapidIO support for Linux.
+    http://lwn.net/Articles/139118/
+[4] Matt Porter. RapidIO for Linux. Ottawa Linux Symposium, 2005
+    http://www.kernel.org/doc/ols/2005/ols2005v2-pages-43-56.pdf
diff -puN /dev/null Documentation/rapidio/sysfs.txt
--- /dev/null
+++ a/Documentation/rapidio/sysfs.txt
@@ -0,0 +1,79 @@
+                         RapidIO sysfs Files
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+1. Device Subdirectories
+------------------------
+
+For each RapidIO device, the RapidIO subsystem creates files in an individual
+subdirectory with the following name, /sys/bus/rapidio/devices/<device_name>.
+
+The format of device_name is "nn:d:iiii", where:
+
+nn - two-digit hexadecimal ID of RapidIO network where the device resides
+d  - device typr: 'e' - for endpoint or 's' - for switch
+iiii - four-digit device destID for endpoints, or switchID for switches
+
+For example, below is a list of device directories that represents a typical
+RapidIO network with one switch, one host, and two agent endpoints, as it is
+seen by the enumerating host (destID = 1):
+
+/sys/bus/rapidio/devices/00:e:0000
+/sys/bus/rapidio/devices/00:e:0002
+/sys/bus/rapidio/devices/00:s:0001
+
+NOTE: An enumerating or discovering endpoint does not create a sysfs entry for
+itself, this is why an endpoint with destID=1 is not shown in the list.
+
+2. Attributes Common for All Devices
+------------------------------------
+
+Each device subdirectory contains the following informational read-only files:
+
+       did - returns the device identifier
+       vid - returns the device vendor identifier
+device_rev - returns the device revision level
+   asm_did - returns identifier for the assembly containing the device
+   asm_rev - returns revision level of the assembly containing the device
+   asm_vid - returns vendor identifier of the assembly containing the device
+
+In addition to the files listed above, each device has a binary attribute file
+that allows read/write access to the device configuration registers using
+the RapidIO maintenance transactions:
+
+ config - reads from and writes to the device configuration registers.
+
+This attribute is similar in behavior to the "config" attribute of PCI devices
+and provides an access to the RapidIO device registers using standard file read
+and write operations.
+
+3. Endpoint Device Attributes
+-----------------------------
+
+Currently Linux RapidIO subsystem does not create any endpoint specific sysfs
+attributes. It is possible that RapidIO master port drivers and endpoint device
+drivers will add their device-specific sysfs attributes but such attributes are
+outside the scope of this document.
+
+4. Switch Device Attributes
+---------------------------
+
+RapidIO switches have additional attributes in sysfs. RapidIO subsystem supports
+common and device-specific sysfs attributes for switches. Because switches are
+integrated into the RapidIO subsystem, it offers a method to create
+device-specific sysfs attributes by specifying a callback function that may be
+set by the switch initialization routine during enumeration or discovery process.
+
+4.1 Common Switch Attributes
+
+ routes - reports switch routing information in "destID port" format. This
+          attribute reports only valid routing table entries, one line for
+          each entry.
+
+4.2 Device-specific Switch Attributes
+
+Device-specific switch attributes are listed for each RapidIO switch driver
+that exports additional attributes.
+
+IDT_GEN2:
+ errlog - reads contents of device error log until it is empty.
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-rapidio-documentation.patch

