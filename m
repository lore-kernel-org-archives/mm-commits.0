Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523F31DFDE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836314; cv=none; b=U77tVcrFR3hbP4ej7IhDVifeNDCeA2GWuXTA/cNYoKJRypf/QV5oL1B4nGo9L4dlkxpNbtCM+SxldyR/AXKtQjl9SGhfCXMs4atqacRoNYAxG16OKXUgZTVypl6k9ma8iwbdR9PQHuNEKy2uwrbARbHq7utmVbBXcdpddq1mO6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836314; c=relaxed/simple;
	bh=iR0/VxjROrXNFl54W0tpun9rloDY149BTMIlRCjXOEg=;
	h=Date:To:From:Subject:Message-Id; b=GiG78x+XigLXrXI2JTXIJvXjtT+93APrcpID9HVnTDj9pnX2W8XfOgxI2e3Gz4JpouIW2luwkcTiqPNdKZY1np15dDzzEswNVrxr6JowjEya3gCIBjFRC/vC5JvV9TcCC8MTQaFD2HENlzsDtizC+6toGDBZYhbPSg+tAW2dC90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EZri65tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EZri65tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224F8C4CEDD;
	Tue, 14 Jan 2025 06:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836314;
	bh=iR0/VxjROrXNFl54W0tpun9rloDY149BTMIlRCjXOEg=;
	h=Date:To:From:Subject:From;
	b=EZri65tlBC7QdteF+cEmagu3iSHK9kGcde2cgfIpya91e+7L0/s4ppHBkTWJGx2Qp
	 FrtGnuEoUGj8Vnca5Llo53VKElPkuGaruW/j3QE3S0qqDcI/9bjZIIctp5c89gDBLE
	 vMNlTaHs3i2RqJE05FYXiQTypytqyXTOG60TT9Co=
Date: Mon, 13 Jan 2025 22:31:53 -0800
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,kernel@xen0n.name,gregkh@linuxfoundation.org,david@redhat.com,corbet@lwn.net,chenhuacai@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-build-time-option-for-hotplug-memory-default-online-type-v4.patch removed from -mm tree
Message-Id: <20250114063154.224F8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-build-time-option-for-hotplug-memory-default-online-type-v4
has been removed from the -mm tree.  Its filename was
     mm-add-build-time-option-for-hotplug-memory-default-online-type-v4.patch

This patch was dropped because it was folded into mm-add-build-time-option-for-hotplug-memory-default-online-type.patch

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm-add-build-time-option-for-hotplug-memory-default-online-type-v4
Date: Thu, 26 Dec 2024 11:29:18 -0700

update KConfig comments

Link: https://lkml.kernel.org/r/20241226182918.648799-1-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/Kconfig~mm-add-build-time-option-for-hotplug-memory-default-online-type-v4
+++ a/mm/Kconfig
@@ -554,7 +554,7 @@ choice
 	prompt "Memory Hotplug Default Online Type"
 	default MHP_DEFAULT_ONLINE_TYPE_OFFLINE
 	help
-	  Default memory type for driver managed hotplug memory.
+	  Default memory type for hotplugged memory.
 
 	  This option sets the default policy setting for memory hotplug
 	  onlining policy (/sys/devices/system/memory/auto_online_blocks) which
@@ -575,7 +575,7 @@ choice
 config MHP_DEFAULT_ONLINE_TYPE_OFFLINE
 	bool "offline"
 	help
-	  Driver managed memory will not be onlined by default.
+	  Hotplugged memory will not be onlined by default.
 	  Choose this for systems with drivers and user policy that
 	  handle onlining of hotplug memory policy.
 
@@ -583,22 +583,22 @@ config MHP_DEFAULT_ONLINE_TYPE_ONLINE_AU
 	bool "auto"
 	help
 	  Select this if you want the kernel to automatically online
-	  memory into the zone it thinks is reasonable. This memory
-	  may be utilized for kernel data (e.g. page tables).
+	  hotplugged memory into the zone it thinks is reasonable.
+	  This memory may be utilized for kernel data.
 
 config MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL
 	bool "kernel"
 	help
 	  Select this if you want the kernel to automatically online
-	  hotplug memory into a zone capable of being used for kernel
-	  data (e.g. page tables). This typically means ZONE_NORMAL.
+	  hotplugged memory into a zone capable of being used for kernel
+	  data. This typically means ZONE_NORMAL.
 
 config MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE
 	bool "movable"
 	help
 	  Select this if you want the kernel to automatically online
 	  hotplug memory into ZONE_MOVABLE. This memory will generally
-	  not be utilized for kernel data (e.g. page tables).
+	  not be utilized for kernel data.
 
 	  This should only be used when the admin knows sufficient
 	  ZONE_NORMAL memory is available to describe hotplug memory,
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-add-build-time-option-for-hotplug-memory-default-online-type.patch

