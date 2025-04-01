Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A586521D5A2
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545909; cv=none; b=Jl8ghwSLk6gCdnXnx4CbgYsaytfVM/yZHkjFgoC5A6cy30n42optYZO4C+hF5OJPjdrmG9GbSUq6sNDHEFwy2cMVxn2O9gdwOUQGc+uJzNenGvDJdOVyn7hKm76AxgLZ6zuAqwhgn4P/UEA8YUEmviW08mH2qDZd4m4ydbOE+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545909; c=relaxed/simple;
	bh=QiWyEa/OlVpOiojt2SQYlyyle9fUHhxi98U32FdzV84=;
	h=Date:To:From:Subject:Message-Id; b=a4mn8pZyuyQSf1XLKhFCQmqD2ps1hAlr7QKLdOKo5U0HzRFHJf0xD9sKPwy75wRxbbkd6T8eiL3NmA83b3Wpq8dQOWja636k5p7uyV7DURrT0vJQSlggkoP35QSHXh/ySY0qxj7fwbrxKc0WQDFi5B18kQ6U6WC3jY7Wy/9zDXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=moofkVN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="moofkVN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A59C4CEE4;
	Tue,  1 Apr 2025 22:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545909;
	bh=QiWyEa/OlVpOiojt2SQYlyyle9fUHhxi98U32FdzV84=;
	h=Date:To:From:Subject:From;
	b=moofkVN9kdhaBY70W/GQR/7Rbc0E8vF4wV7IKRjMqCEz1kmcH0N7OF8GddhOBN5+A
	 /mP9cXikBntWECOjzGzLVgLIkqv6B3IFTQilDIC7DOcIq3MYlJs7hli2aAaUei01KT
	 RG65kEttQNxmXErJLE1a9gCNpiEEZU6vne9UWGZ0=
Date: Tue, 01 Apr 2025 15:18:28 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jeffxu@chromium.org,gor@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-sysmap-generic-vdso-vvar-mapping.patch removed from -mm tree
Message-Id: <20250401221829.65A59C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: generic vdso vvar mapping
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-generic-vdso-vvar-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: mseal sysmap: generic vdso vvar mapping
Date: Tue, 11 Mar 2025 13:33:25 +0100

With the introduction of the generic vdso data storage the VM_SEALED_SYSMAP
vm flag must be moved from the architecture specific
_install_special_mapping() call [1] [2] which maps the vvar mapping to
generic code.

[1] https://lkml.kernel.org/r/20250305021711.3867874-4-jeffxu@google.com
[2] https://lkml.kernel.org/r/20250305021711.3867874-5-jeffxu@google.com

Link: https://lkml.kernel.org/r/20250311123326.2686682-2-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vdso/datastore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/vdso/datastore.c~mseal-sysmap-generic-vdso-vvar-mapping
+++ a/lib/vdso/datastore.c
@@ -99,7 +99,8 @@ const struct vm_special_mapping vdso_vva
 struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned long addr)
 {
 	return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SIZE,
-					VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP | VM_PFNMAP,
+					VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP |
+					VM_PFNMAP | VM_SEALED_SYSMAP,
 					&vdso_vvar_mapping);
 }
 
_

Patches currently in -mm which might be from hca@linux.ibm.com are


