Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421FE14600D
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247145; cv=none; b=qUZhBRbqZgKlQAKcsyBz9VY7RjMd8NLVLf3h4jlGgcMRNjZgDxmPMVnmBce5b4+OuFAJkwF3x37OdCCIowqsGgUqGHkfvP1kyvGLmnikcgwduE6A6SLQFzhWr9dCFJ/WsJNkKtEpT6nF11St48yD3iImtByhT+pQ16Px7t07K+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247145; c=relaxed/simple;
	bh=2DiOoFcdwk/qgwPAIjY/gpBon3D4PUI13uqqD3CP//A=;
	h=Date:To:From:Subject:Message-Id; b=FcxT9pkBWBquZEZOEtQS0N+YQP2EwnK+F8iUxEtz4iV+1kJiRy33j2c9DF0ThMzEyipzBvNRTBB5ncOjTeFLwQsIF2HHH23v2NYNKkUzjrqH/E9Jtk4swIFXx/2mleS12flmXEWJHCAVpBOZGRUp4PXvwB1cyHPI8I022ultDYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HUmlNorb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HUmlNorb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C041CC4CED1;
	Thu, 26 Dec 2024 21:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247143;
	bh=2DiOoFcdwk/qgwPAIjY/gpBon3D4PUI13uqqD3CP//A=;
	h=Date:To:From:Subject:From;
	b=HUmlNorbRuY6OKsHfU3dxGjRNOKURpt4vwb3YkFgj5kub5Z36uE8XJoCfG2Yp29PF
	 Dtb55DXe1HJPcdiC3jogU23D9CHD1aRU+eyTL5Hmg63AYAXqvFoYCW3t6ifr/0l2ZK
	 TRmTbrdlM5KJMOfiW/O/rytR72eQLKHyYmPPEKLM=
Date: Thu, 26 Dec 2024 13:05:43 -0800
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,kernel@xen0n.name,gregkh@linuxfoundation.org,david@redhat.com,corbet@lwn.net,chenhuacai@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-build-time-option-for-hotplug-memory-default-online-type-v4.patch added to mm-unstable branch
Message-Id: <20241226210543.C041CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-build-time-option-for-hotplug-memory-default-online-type-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-build-time-option-for-hotplug-memory-default-online-type-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-build-time-option-for-hotplug-memory-default-online-type-v4.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-add-build-time-option-for-hotplug-memory-default-online-type-v4.patch

