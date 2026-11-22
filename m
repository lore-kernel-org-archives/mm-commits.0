Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795341168;
	b=AxJspCPOqsNkZImeVY80Zc6Mig/BVJBGNFOcQ9VJVs6G4ucCCiyBY9F+8dPHKbACs3WQ
	 gi4doFqmDWZGFThumCteXSDxg7LbQd2nV4v561lN15+ludBcJqNxaPOcHJiyZuaozTJWy
	 VK4/BdBYtAphk864mGEbuUnxqnRv6Vj4qn/XhoqEoqdCQzt9MErMnVznkaEE8DsuBzjdD
	 Qoh9g/HXgw8xjvnYZq9+K+ezyASuC8XR6LepS9CLn7feXEC1nv/BYYhWd4M3tUSh+CQOp
	 i0/gEenk6tVe5gAD3AkI+ddppH6NSoHA3jl0Fx00o4jJ0YnSk0gBT2o8k0GQS+775aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795341168;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=530GHac6mJJlARMcZhnSyYnD4ziuOybglG1oyg7MtIg=;
	b=qs8pfgaP5qOSR0a7eLXl95w/8M7ce9odkv5iHfEEsAB+XKZ6IzMa/jN1hhoH0v018poh
	 ZdR5+LrYECtZdrHMcrvdI2/y/P6+wZRgKs6ngBK4WLCVx9T4pIAh7zohFyiCdT4SDak62
	 KxfKTDXsMI6iahxZJLFEcBbN9KWz83Dk6LkRypDEAn1t2s+VbMFL26RNcTBeewp2gA3bz
	 OA5iXs9pkjBRCyWY4M3KOb5lMcPrIC/mOsZcRTzzAUFmVF9dJo+fy4c4BzIvsl3T+rmGy
	 AaTQ6Oy+u/N9kKwxRFamhL/BSIHreS7Uc7CekTg4oUN0C7kykJCeM2wz3xrt7Jrdijg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wBlI7zm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8F606A32A;
	Sun, 22 Nov 2026 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wBlI7zm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1F21F000CF;
	Sun, 22 Nov 2026 09:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795341167;
	bh=530GHac6mJJlARMcZhnSyYnD4ziuOybglG1oyg7MtIg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wBlI7zm4CR5lvitfKL08hDnNAC74F8f+kW0/gspGe5h/qgWpc/cDxmPZCWZGcZXMK
	 6435A7gXWZuVpxZl8DxkEyJP2dF3PN0HG6NxxY/BpORklPI0tlIcLZ+44lGFN1fJz8
	 8PPE4FYITG56tMZ4obJfZ1VG4loUfPk0as+pg458=
Date: Sun, 22 Nov 2026 01:52:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mika =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc: Aveline Noir <jm5905938@gmail.com>, jgg@nvidia.com, leonro@nvidia.com,
 airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost
 <matthew.brost@intel.com>, mm-commits@vger.kernel.org, Patchwork
 <patchwork@emeril.freedesktop.org>, SeongJae Park <sj@kernel.org>,
 thomas.hellstrom@linux.intel.com, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-Id: <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
In-Reply-To: <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
References: <179342234355.4.16705453209886955762@gmail.com>
	<20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
	<36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Nov 2026 07:55:37 +0200 Mika Penttil=E4 <mpenttil@redhat.com> wr=
ote:

> > So it accidentally found a bug in lib/test_hmm.c on the way.  "The QEMU
> > run exposed a real test_hmm bug: a second open of /dev/hmm_dmirror0 can
> > put a device-private page into its page table, then dmirror_do_read()
> > tries to copy from that non-CPU-accessible page and oopses".  I'll prep
> > a fix for that separately.
>=20
> I noticed that also and will make changes around it in my series.

I came up with the below.  It all tested out OK.  wdyt?  I guess it
should have cc:stable>



From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_hmm: use backing pages for device-private mirror faults
Date: Sat, 21 Nov 2026 17:06:45 -0800

When one hmm_dmirror descriptor migrates memory to device-private and a
second descriptor reads it, dmirror_do_fault() stores the device page in
the second descriptor's page table.  dmirror_do_read() then passes that
page to memcpy_from_page(), which can oops the kernel.  This was
reproduced with an unprivileged process using the fake device in a QEMU
guest.

Store the corresponding RAM backing page instead.  For a large device
folio, retain the subpage offset when selecting the backing page; using
the backing folio's head for every entry would return the wrong data.=20
Extend the existing PMD migration selftest to read the last subpage
through a second open before faulting the memory back to RAM.

Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
---
tl;dr: The unpatched kernel oopsed when an unprivileged process opened the
fake HMM device twice, migrated an anonymous 2 MB PMD to device-private
memory through one descriptor, then accessed its last page through the
other.  The patched kernel returned the expected bytes on all three ioctl
paths.

A was reproduced and saved before B was built.  As uid 65534, a static
userspace program verified that all 512 pages were device-private PMD
entries.  A READ of the last page through the second descriptor produced a
KASAN-enabled kernel Oops in dmirror_do_read().  Independent A boots also
oopsed on WRITE and READ_UNLOCKED at the same last-page access.

With only this patch added, READ and READ_UNLOCKED returned the expected
0x0a byte, and WRITE returned the expected 0xa5 byte after migration back
to RAM.  The modified in-tree hmm_device_private.migrate_anon_huge_fault
selftest also passed (1/1).

This reproduces a userspace-triggered kernel Oops in the fake HMM device
used by test_hmm; it does not establish reachability through physical GPU
hardware.  QEMU guests used matching kernel configurations with
CONFIG_TEST_HMM=3Dy and KASAN.  The guest device permissions were set for
uid 65534.

 lib/test_hmm.c                         |    7 +++++++
 tools/testing/selftests/mm/hmm-tests.c |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

--- a/lib/test_hmm.c~lib-test_hmm-use-backing-pages-for-device-private-mirr=
or-faults
+++ a/lib/test_hmm.c
@@ -292,6 +292,13 @@ static int dmirror_do_fault(struct dmirr
 		page =3D hmm_pfn_to_page(*pfns);
 		WARN_ON(!page);
=20
+		if (is_device_private_page(page)) {
+			struct folio *folio =3D page_folio(page);
+			struct page *backing =3D BACKING_PAGE(&folio->page);
+
+			page =3D folio_page(page_folio(backing),
+					  folio_page_idx(folio, page));
+		}
 		entry =3D page;
 		if (*pfns & HMM_PFN_WRITE)
 			entry =3D xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
--- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-use-backing-pages=
-for-device-private-mirror-faults
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	void *old_ptr;
 	void *map;
 	int pagemap_fd;
+	int fd2 =3D -1;
 	int *ptr;
 	int ret;
=20
@@ -2143,12 +2144,25 @@ TEST_F(hmm, migrate_anon_huge_fault)
 		}
=20
 		close(pagemap_fd);
+
+		/* A second open must read the last device-private subpage. */
+		fd2 =3D hmm_open(variant->device_number);
+		ASSERT_GE(fd2, 0);
+		buffer->ptr =3D (char *)map + (npages - 1) * self->page_size;
+		ret =3D hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr =3D map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(*(int *)buffer->mirror,
+			  (npages - 1) * self->page_size / sizeof(int));
 	}
=20
 	/* Fault pages back to system memory and check them. */
 	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
=20
+	if (fd2 >=3D 0)
+		ASSERT_EQ(close(fd2), 0);
 	buffer->ptr =3D old_ptr;
 	hmm_buffer_free(buffer);
 }
_

