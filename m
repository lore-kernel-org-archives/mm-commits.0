Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED42BE4D
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759100; cv=none; b=Jrb+wVRnjsa87S8YjPv2vjCbKGtC19ABWgiIbyRTPxvsXnyD+IzXpb7HZoXhpCuEAwVP1JD0w0KxftyUOlbwaHYchCcdyBBXz282ZOTAamcjyu5WOyWjalsaLvBQmtLX3hnj+Di0s+XxuT+76qatDXBr0B476Fuv2QFrgfgdHAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759100; c=relaxed/simple;
	bh=U3m1qf9RkSn++WuEYpZz3t4bgQd4J19+IHBMcJ7OgKQ=;
	h=Date:To:From:Subject:Message-Id; b=A7cu/OyrEyo8G3M+pD0WEpRcA5g7a91iWrS/96DRLjPehwEzJMxvabZFueB/8biTZArjGgRFw4sIEmQE4jdOxy/8Wnb+9GUmubm/H4PKCrmKj+ZwADmxqUmJ0erqRWEMoKj6Pd45T0Fc/2cmQTxKvnDBbJYpbCzZm5vCE5U4ijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NZ/qA05y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NZ/qA05y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA7EC433F1;
	Wed,  6 Mar 2024 21:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759099;
	bh=U3m1qf9RkSn++WuEYpZz3t4bgQd4J19+IHBMcJ7OgKQ=;
	h=Date:To:From:Subject:From;
	b=NZ/qA05yJupe9y3B1a854CXSwtjQhihyI+aqZjyH+raOo9et6LM5NQiUfgE4PbuFG
	 DeWgh9/b6imFSQmGDZ3oV8YOh9AO6S/UftHFLnbUd+LztmgFWhLQ4+A/VuOmyVgHYZ
	 ZYIhyqBRWNVi/wn4HAgG4RpzGiK2p1JnJ1eKu/1Y=
Date: Wed, 06 Mar 2024 13:04:58 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,steffen.klassert@secunet.com,rientjes@google.com,rdunlap@infradead.org,paulmck@kernel.org,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,jane.chu@oracle.com,david@redhat.com,daniel.m.jordan@oracle.com,adobriyan@gmail.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-have-config_hugetlbfs-select-config_padata.patch removed from -mm tree
Message-Id: <20240306210459.7CA7EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: have CONFIG_HUGETLBFS select CONFIG_PADATA
has been removed from the -mm tree.  Its filename was
     hugetlb-have-config_hugetlbfs-select-config_padata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: have CONFIG_HUGETLBFS select CONFIG_PADATA
Date: Thu, 22 Feb 2024 22:04:19 +0800

Allow hugetlb use padata_do_multithreaded for parallel initialization. 
Select CONFIG_PADATA in this case.

Link: https://lkml.kernel.org/r/20240222140422.393911-7-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/Kconfig~hugetlb-have-config_hugetlbfs-select-config_padata
+++ a/fs/Kconfig
@@ -261,6 +261,7 @@ menuconfig HUGETLBFS
 	depends on X86 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	depends on (SYSFS || SYSCTL)
 	select MEMFD_CREATE
+	select PADATA if SMP
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
_

Patches currently in -mm which might be from gang.li@linux.dev are


