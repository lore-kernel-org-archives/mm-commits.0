Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367661;
	b=noiNmm9owcSD/6ikN2yz213Tp1KoPkPJfJ797/n786/aLpTQWpK6qqlMI8WOOXMIHfqT
	 rPVkPhCoaEyWu82krCg/SCPsRg/ViTo6H9EpnQDvGp6UuRHPW73TI2ByPj+RKTfO4YjDU
	 m4GezmPjoho2E1SjW+xGGMOJpxPCEQl0JuEDmBH2KV81VVwPhzkAlATFysstZYJiBzvaL
	 5GqQc3RgcsiRuKUyFyAT1+dbbZPu2lVBNW9spG4gxGMPNBMTlTt6CVDkQmS6mbCduiPaN
	 OjDNJyqpeCREQv/gt9AR6jYpacIBWnCePO2WI1l6sjcmHy+RIS6hs7CAAMWN48ur3Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367661;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5JGbsedU74vIQ/0gQEWTkA66OhpSi5QLuKHx51jgv6o=;
	b=hz6hZbiGdtisPFbs60iieDgzCA1+3D0NrTTWG4rirjvGMDzzhg1Dj2i1gmTGmPOa26Zg
	 qGnRM5ZpuTpPM00AlJS+t0B8XVTOXU5LCngRGSD/jTCynKFu10r9iqWy6s25LIx24zQc2
	 7NBtbYzkDPPksH1z5MOAGNGq3OLEaB6I13cEej4+j+I1lCWV4rob3B/G+leeoiV+5aPgF
	 B629XhAI3N/H3g6x8LGj3QIFnZjSONWcvQUd8Y41z/adbrbbXpDTASHQfDiGDlbquKDpo
	 vtYF0ovVDGxQRmZtVMT0/tHds5vUpzwijT+n71f0EN4ztp0SHquFGxUrPUFa+AzW2vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UK5LpKdm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F88C606A32A;
	Sun, 22 Nov 2026 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UK5LpKdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEB51F000C4;
	Sun, 22 Nov 2026 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795367660;
	bh=5JGbsedU74vIQ/0gQEWTkA66OhpSi5QLuKHx51jgv6o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UK5LpKdmOWL0+QIg66xeuCB/MCO3KleNEYpYNhkPYguIjSJsVEOTfFAFSYArDoe57
	 S9UVOHkKTNDRYrqblFi9Cs7MEWehlW8R2JFhx1Heql/svJVetyCbF8b2SY2y3FQoHX
	 trt7AR+PG2xFis8l1vlFBhzeunpgbz/Wn7bqWyXA=
Date: Sun, 22 Nov 2026 09:14:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mika =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc: Aveline Noir <jm5905938@gmail.com>, airlied@gmail.com,
 apopple@nvidia.com, balbirs@nvidia.com, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@nvidia.com, jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>,
 mm-commits@vger.kernel.org, Patchwork <patchwork@emeril.freedesktop.org>,
 Shuah Khan <shuah@kernel.org>, SeongJae Park <sj@kernel.org>,
 thomas.hellstrom@linux.intel.com, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-Id: <20261122091419.f82e88761dbd12771fb6c976@linux-foundation.org>
In-Reply-To: <af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
References: <179342234355.4.16705453209886955762@gmail.com>
	<20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
	<36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
	<20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
	<179535872126.34.4789080961796247940.b4-reply@b4>
	<af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
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

On Sun, 22 Nov 2026 18:41:39 +0200 Mika Penttil=E4 <mpenttil@redhat.com> wr=
ote:

>=20
> On 11/22/26 16:45, Aveline Noir wrote:
>=20
> > Hi Andrew,
> >
> > On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:
> >
> >> Store the corresponding RAM backing page instead.
> > This avoids the oops on the first read through the second descriptor,
> > but leaves a stale backing page pointer after CPU faultback.
> >
> > Since the mirror XArray entries don't take a page reference, they rely
> > on invalidation.  When the CPU later faults the page back to RAM,
> > dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
> > mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
> > migrating descriptor's entry before the backing folio is freed.  The
> > second descriptor still points to that freed backing page.
> >
> > Reading the same page again through the second descriptor in QEMU
> > triggers a KASAN use-after-free in dmirror_do_read(), and the read
> > returns the stale data instead of what the CPU wrote.
>=20
> I think this is right, but a fairly artificial scenario: it needs two
> descriptors open on the same test device in one test, a migration through=
 one,
> a read through the other, a CPU fault back, and then another read through
> the second descriptor..
>=20
> The fix lets the device private page content be read without an oops
> in the context of one fd which is an improvement.=20

May as well fix it.  I'll test this updated version.

Mika, please feel free to take this over, perhaps integrate it (or
something like it) into whatever you've got going on?  Or not, let me
know ;)


From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_hmm: invalidate all mirrors on device-private migration
Date: Sun, 22 Nov 2026 08:53:12 -0800

When one open of the fake HMM device migrates a folio to device-private
memory, a second open can fault the same address into its mirror page
table. The second mirror then stores the inaccessible device page, which
can oops the kernel when dmirror_do_read() copies from it. Store the
corresponding RAM backing subpage instead.

That conversion also makes the backing page's lifetime significant to
the second mirror. migrate_vma_setup() notifies all mirrors before CPU
faultback, but dmirror_interval_invalidate() skips the notification for
every open on the same device. The faulting open clears only its own
XArray entry. The other open can read or write the backing page after
migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
and stale data through the second open.

Handle migration invalidation for every mirror under its mutex. This
clears pointers before faultback can free the backing pages and waits
for an active mirror read or write. During system-to-device migration,
the migrating open installs new entries after migration; other opens
refault on their next access. Remove the now redundant XArray erase
from the faultback copy loop.

Extend the PMD migration selftest to read its last device-private
subpage through a second open, then fault it back to RAM, change it,
and read the new value through that open. The trigger is available to
a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
enabled; it does not depend on physical GPU hardware.

Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@lin=
ux-foundation.org
Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-repl=
y@b4
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Aveline Noir <jm5905938@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mika Penttil=E4 <mpenttil@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>

 lib/test_hmm.c                         |   20 +++++++-----------
 tools/testing/selftests/mm/hmm-tests.c |   25 +++++++++++++++++++++++
 2 files changed, 33 insertions(+), 12 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-=
migration
+++ a/lib/test_hmm.c
@@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
 		page =3D hmm_pfn_to_page(*pfns);
 		WARN_ON(!page);
=20
+		if (is_device_private_page(page)) {
+			struct folio *folio =3D page_folio(page);
+
+			page =3D BACKING_PAGE(&folio->page) +
+				folio_page_idx(folio, page);
+		}
 		entry =3D page;
 		if (*pfns & HMM_PFN_WRITE)
 			entry =3D xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
@@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
 {
 	struct dmirror *dmirror =3D container_of(mni, struct dmirror, notifier);
=20
-	/*
-	 * Ignore invalidation callbacks for device private pages since
-	 * the invalidation is handled as part of the migration process.
-	 */
-	if (range->event =3D=3D MMU_NOTIFY_MIGRATE &&
-	    range->owner =3D=3D dmirror->mdevice)
-		return true;
-
 	if (mmu_notifier_range_blockable(range))
 		mutex_lock(&dmirror->mutex);
 	else if (!mutex_trylock(&dmirror->mutex))
@@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
=20
 			src_page =3D pfn_to_page(page_to_pfn(spage) + i);
=20
-			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
 			addr +=3D PAGE_SIZE;
 			copy_highpage(dst_page, src_page);
 		}
@@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
 	}
 	migrate_vma_pages(&args);
 	/*
-	 * No device finalize step is needed since
-	 * dmirror_devmem_fault_alloc_and_copy() will have already
-	 * invalidated the device page table.
+	 * The migration notifier has invalidated all mirror page tables
+	 * before the backing pages can be freed.
 	 */
 	migrate_vma_finalize(&args);
 err:
--- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-mi=
rrors-on-device-private-migration
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	void *old_ptr;
 	void *map;
 	int pagemap_fd;
+	int fd2 =3D -1;
 	int *ptr;
 	int ret;
=20
@@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
 		}
=20
 		close(pagemap_fd);
+
+		/* Read a device-private subpage through another open. */
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
+	if (fd2 >=3D 0) {
+		/* This open must not retain the freed device backing page. */
+		ptr[(npages - 1) * self->page_size / sizeof(*ptr)] =3D -1;
+		buffer->ptr =3D (char *)map + (npages - 1) * self->page_size;
+		ret =3D hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr =3D map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(buffer->faults, 1);
+		ASSERT_EQ(*(int *)buffer->mirror, -1);
+		ASSERT_EQ(close(fd2), 0);
+	}
+
 	buffer->ptr =3D old_ptr;
 	hmm_buffer_free(buffer);
 }
_

