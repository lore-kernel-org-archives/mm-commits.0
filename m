Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4970268690
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282421; cv=none; b=qQE3iCE/a0ItUCg76ah23/LRZCIIrrKjwpWf/KRrxH8T2wNfK2++2GsEUEolHAIYWfkBscmJq7Rch0RfjmWqWPDfxq9OXFCAvg9uYUHMrNrj7TL0ftmUzxD3FpdsTq2jLYG3q0DeMEYy0I2vdTOhPniXF4bimKVx+0U++63TIe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282421; c=relaxed/simple;
	bh=NfqbC3DUsdVMLGIu2CtnOOyUjVyEc/tqSJKZ//4YC0A=;
	h=Date:To:From:Subject:Message-Id; b=WdRQaLoMFnxK8Qmwu5pjMBL4Uqf6UNtEl3pR59c4AMyc9TtswiNx4yEBTKhvGOdz/I/oUL5EANpnszjS63XKDCycNR0epzMK9ib5Si+hGJa9SQwRgwwo1QhEdFLyDCh7jxhpd675ha+YydIhu0+JMVvwD2Y64Y7EyialXiTCAdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1HQNWS1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1HQNWS1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84283C4CEF8;
	Thu, 27 Nov 2025 22:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282421;
	bh=NfqbC3DUsdVMLGIu2CtnOOyUjVyEc/tqSJKZ//4YC0A=;
	h=Date:To:From:Subject:From;
	b=1HQNWS1S/6A4yzhpDEI6eszPZiKd9TRuBoiiQ1YmpchmwuDnJ3ExkAdvwkGYkGupw
	 RnFV536oXODDYFK1gsxNgCpg3iNfAVuXUR9j+bktwMdUjSd4qUa6PG/03OC+miQ6YR
	 puTn5dDTK7MIDJuPeieFd/TMcV+qrrYMVyhwTnR8=
Date: Thu, 27 Nov 2025 14:27:01 -0800
To: mm-commits@vger.kernel.org,yoann.congal@smile.fr,yesanishhere@gmail.com,yanjun.zhu@linux.dev,witu@nvidia.com,wagi@kernel.org,vincent.guittot@linaro.org,tj@kernel.org,tglx@linutronix.de,stuart.w.hayes@gmail.com,song@kernel.org,skhawaja@google.com,saeedm@nvidia.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,rdunlap@infradead.org,quic_zijuhu@quicinc.com,pratyush@kernel.org,pasha.tatashin@soleen.com,parav@nvidia.com,ojeda@kernel.org,myungjoo.ham@samsung.com,mmaurer@google.com,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,lukas@wunner.de,linux@weissschuh.net,leonro@nvidia.com,leon@kernel.org,lennart@poettering.net,kanie@linux.alibaba.com,Jonathan.Cameron@huawei.com,joel.granados@kernel.org,jgg@nvidia.com,jannh@google.com,ira.weiny@intel.com,ilpo.jarvinen@linux.intel.com,hughd@google.com,hpa@zytor.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,graf@amazon.com,dmatlack@google.com,djeffery@redhat.com,david@redhat.com,dan.j.williams@intel.com,dakr@kernel.org,cw00.choi@samsung.com,corbet@lwn.net,chrisl@kernel.org,chenridong@huawei.com,brauner@kernel.org,bp@alien8.de,bhelgaas@google.com,bartosz.golaszewski@linaro.org,axboe@kernel.dk,anna.schumaker@oracle.com,andriy.shevchenko@linux.intel.com,aliceryhl@google.com,aleksander.lobakin@intel.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docs-add-documentation-for-memfd-preservation-via-luo.patch removed from -mm tree
Message-Id: <20251127222701.84283C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: add documentation for memfd preservation via LUO
has been removed from the -mm tree.  Its filename was
     docs-add-documentation-for-memfd-preservation-via-luo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: docs: add documentation for memfd preservation via LUO
Date: Tue, 25 Nov 2025 11:58:45 -0500

Add the documentation under the "Preserving file descriptors" section of
LUO's documentation.

Link: https://lkml.kernel.org/r/20251125165850.3389713-16-pasha.tatashin@soleen.com
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: David Matlack <dmatlack@google.com>
Cc: Aleksander Lobakin <aleksander.lobakin@intel.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: anish kumar <yesanishhere@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Wagner <wagi@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guixin Liu <kanie@linux.alibaba.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Cc: Parav Pandit <parav@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: William Tu <witu@nvidia.com>
Cc: Yoann Congal <yoann.congal@smile.fr>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/liveupdate.rst   |    7 ++++++
 Documentation/mm/index.rst              |    1 
 Documentation/mm/memfd_preservation.rst |   23 ++++++++++++++++++++++
 MAINTAINERS                             |    1 
 4 files changed, 32 insertions(+)

--- a/Documentation/core-api/liveupdate.rst~docs-add-documentation-for-memfd-preservation-via-luo
+++ a/Documentation/core-api/liveupdate.rst
@@ -23,6 +23,13 @@ Live Update Orchestrator ABI
 .. kernel-doc:: include/linux/kho/abi/luo.h
    :doc: Live Update Orchestrator ABI
 
+The following types of file descriptors can be preserved
+
+.. toctree::
+   :maxdepth: 1
+
+   ../mm/memfd_preservation
+
 Public API
 ==========
 .. kernel-doc:: include/linux/liveupdate.h
--- a/Documentation/mm/index.rst~docs-add-documentation-for-memfd-preservation-via-luo
+++ a/Documentation/mm/index.rst
@@ -48,6 +48,7 @@ documentation, or deleted if it has serv
    hugetlbfs_reserv
    ksm
    memory-model
+   memfd_preservation
    mmu_notifier
    multigen_lru
    numa
diff --git a/Documentation/mm/memfd_preservation.rst a/Documentation/mm/memfd_preservation.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/mm/memfd_preservation.rst
@@ -0,0 +1,23 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+==========================
+Memfd Preservation via LUO
+==========================
+
+.. kernel-doc:: mm/memfd_luo.c
+   :doc: Memfd Preservation via LUO
+
+Memfd Preservation ABI
+======================
+
+.. kernel-doc:: include/linux/kho/abi/memfd.h
+   :doc: DOC: memfd Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/memfd.h
+   :internal:
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/core-api/kho/concepts`
--- a/MAINTAINERS~docs-add-documentation-for-memfd-preservation-via-luo
+++ a/MAINTAINERS
@@ -14473,6 +14473,7 @@ R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
_

Patches currently in -mm which might be from ptyadav@amazon.de are


