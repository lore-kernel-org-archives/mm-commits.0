From: akpm@linux-foundation.org
Subject: +
 mm-hotplug-probe-interface-is-available-on-several-platforms.patch added to -mm tree
Date: Wed, 11 Jun 2014 15:18:09 -0700
Message-ID: <5398d5a1.I9ZJQ64P+pxaSZ9c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaFKWSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 18:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com

Subject: + mm-hotplug-probe-interface-is-available-on-several-platforms.patch added to -mm tree
To: rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 15:18:09 -0700


The patch titled
     Subject: mm, hotplug: probe interface is available on several platforms
has been added to the -mm tree.  Its filename is
     mm-hotplug-probe-interface-is-available-on-several-platforms.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hotplug-probe-interface-is-available-on-several-platforms.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hotplug-probe-interface-is-available-on-several-platforms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hotplug: probe interface is available on several platforms

Documentation/memory-hotplug.txt incorrectly states that the memory driver
"probe" interface is only supported on powerpc and is vague about its
application on x86.  Clarify the platforms that make this interface
available if memory hotplug is enabled.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN Documentation/memory-hotplug.txt~mm-hotplug-probe-interface-is-available-on-several-platforms Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~mm-hotplug-probe-interface-is-available-on-several-platforms
+++ a/Documentation/memory-hotplug.txt
@@ -209,15 +209,12 @@ If memory device is found, memory hotplu
 
 4.2 Notify memory hot-add event by hand
 ------------
-On powerpc, the firmware does not notify a memory hotplug event to the kernel.
-Therefore, "probe" interface is supported to notify the event to the kernel.
-This interface depends on CONFIG_ARCH_MEMORY_PROBE.
-
-CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
-option is disabled by default since ACPI notifies a memory hotplug event to
-the kernel, which performs its hotplug operation as the result. Please
-enable this option if you need the "probe" interface for testing purposes
-on x86.
+On some architectures, the firmware may not notify the kernel of a memory
+hotplug event.  Therefore, the memory "probe" interface is supported to
+explicitly notify the kernel.  This interface depends on
+CONFIG_ARCH_MEMORY_PROBE and can be configured on powerpc, sh, and x86
+if hotplug is supported, although for x86 this should be handled by ACPI
+notification.
 
 Probe interface is located at
 /sys/devices/system/memory/probe
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-hotplug-probe-interface-is-available-on-several-platforms.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
linux-next.patch

