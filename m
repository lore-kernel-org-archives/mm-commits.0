Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC6F34214F
	for <mm-commits@vger.kernel.org>; Thu,  4 Dec 2025 13:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764853235; cv=none; b=rBQMPAC0x/P+B99ZMHmmocNpRoEOTVAeiIXkvZZw0+B19P7tEr6iOVa9JV9e9F2IYcWhyMy8UlSQnCfEY+XcMjUqzNPQ+Pl2R2kY+9KgdBEy8jNoL8xVJ2JaAVX0B21T4K9u4e5eySO/DSv4WqMWl3hIPJfHl4DKPdecUD1T8R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764853235; c=relaxed/simple;
	bh=yglvG3PPBHkYDd6lHGAtVFOhUkbY0djpaQcrmAeEKGc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=le2KKXFhLB4lASabFlBR5XqzjZGLPddE+9xY4JRbU7yGg3uR7kqhqLdgzPho6GIp3+DGVV2BxcJULV/6UdXTZJQmG8CLOs68/nDgPEEEcbSLBQU5IZBPPNbnASWbQgx1H5ZayKA6Pb9a0yUVMmyv6IsGmZJ1SLt/Q/uRnubnu5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TalHJ9gt; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TalHJ9gt"
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764853229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G5n994p2KAdG3HNkB3DAipRjtx/VlJPO9yBG4bZMjyk=;
	b=TalHJ9gtprNjU/kxAFHQiVkcOk6vMeWcTgAsI0kKiBvsdWlDZeQNHHWu9UOlB7L6WiCrXJ
	x3bhNt6cQL5XAPHJaGEMaYQphgAw4NZQoeQ7OIrQiWFgnc9m0d4qb/2NMHbTsQC6277eg2
	01fXv72i8caluD51U8EpWfDxkgZ1lxM=
Date: Thu, 04 Dec 2025 13:00:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <2f817f0ba6bc68d5e70309858d946597d64bac8b@linux.dev>
TLS-Required: No
Subject: Re: + mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch
 added to mm-hotfixes-unstable branch
To: "Andrey Konovalov" <andreyknvl@gmail.com>, "Kees Cook" <kees@kernel.org>
Cc: mm-commits@vger.kernel.org, vincenzo.frascino@arm.com, urezki@gmail.com,
 stable@vger.kernel.org, ryabinin.a.a@gmail.com, glider@google.com,
 dvyukov@google.com, dakr@kernel.org, "kasan-dev"
 <kasan-dev@googlegroups.com>, "Maciej Wieczor-Retman"
 <maciej.wieczor-retman@intel.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
In-Reply-To: <CA+fCnZeKm4uZuv2hhnSE0RrBvjw26eZFNXC6S+SPDMD0O1vvvA@mail.gmail.com>
References: <20251128185523.B995CC4CEFB@smtp.kernel.org>
 <CA+fCnZeKm4uZuv2hhnSE0RrBvjw26eZFNXC6S+SPDMD0O1vvvA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

December 3, 2025 at 23:18, "Andrey Konovalov" <andreyknvl@gmail.com mailt=
o:andreyknvl@gmail.com?to=3D%22Andrey%20Konovalov%22%20%3Candreyknvl%40gm=
ail.com%3E > wrote:


>=20

>=20>  ------------------------------------------------------
> >  From: Jiayuan Chen <jiayuan.chen@linux.dev>
> >  Subject: mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN
> >  Date: Fri, 28 Nov 2025 19:15:14 +0800
> >=20
>=20Hi Jiayuan,
>=20
>=20Please CC kasan-dev@googlegroups.com when sending KASAN patches.
>=20

Sorry=20about that. I missed it.

> >=20
>=20> Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes=
 two
> >  issues:
> >=20
>=20>  1. In vrealloc, we were missing the KASAN_VMALLOC_VM_ALLOC flag wh=
en
> >  unpoisoning the extended region. This flag is required to correctly
> >  associate the allocation with KASAN's vmalloc tracking.
> >=20
>=20>  Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) expli=
citly
> >  sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with =
it.
> >  vrealloc must behave consistently =E2=80=94 especially when reusing =
existing
> >  vmalloc regions =E2=80=94 to ensure KASAN can track allocations corr=
ectly.
> >=20
>=20>  2. When vrealloc reuses an existing vmalloc region (without alloca=
ting new
> >  pages), KASAN previously generated a new tag, which broke tag-based
> >  memory access tracking. We now add a 'reuse_tag' parameter to
> >  __kasan_unpoison_vmalloc() to preserve the original tag in such case=
s.
> >=20
>=20I think we actually could assign a new tag to detect accesses through
> the old pointer. Just gotta retag the whole region with this tag. But
> this is a separate thing; filed
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220829 for this.
>=20

Thank=20you for your advice. I tested the following modification, and it =
works.

	if (size <=3D alloced_size) {
-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
-				       KASAN_VMALLOC_PROT_NORMAL);
+		p =3D kasan_unpoison_vmalloc(p, size,
+					   KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC);
		/*
		 * No need to zero memory here, as unused memory will have
		 * already been zeroed at initial allocation time or during
		 * realloc shrink time.
		 */
		vm->requested_size =3D size;
		return (void *)p;
	}


> >=20
[...]
>=20Would be good to have tests for vrealloc too. Filed
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220830 for this.
>=20

Thanks,=20I will add test for vrealloc in kasan_test_c.c.

> >=20
>=20> +
> >  kasan_unpoison(start, size, false);
> >  return (void *)start;
> >  }
> >  --- a/mm/vmalloc.c~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-fo=
r-kasan
> >  +++ a/mm/vmalloc.c
> >  @@ -4175,8 +4175,8 @@ void *vrealloc_node_align_noprof(const v
> >  * We already have the bytes available in the allocation; use them.
> >  */
> >  if (size <=3D alloced_size) {
> >  - kasan_unpoison_vmalloc(p + old_size, size - old_size,
> >  - KASAN_VMALLOC_PROT_NORMAL);
> >  + kasan_unpoison_vrealloc(p, size,
> >  + KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC);
> >=20
>=20Orthogonal to this series, but is it allowed to call vrealloc on
> executable mappings? If so, we need to only set
> KASAN_VMALLOC_PROT_NORMAL for non-executable mappings. And
> kasan_poison_vmalloc should not be called for them as well (so we
> likely need to pass a protection flag to it to avoid exposing this
> logic).

Currently, vmalloc implicitly sets kasan_flags |=3D KASAN_VMALLOC_VM_ALLO=
C, meaning the allocated
memory cannot be used for executable code segments. I think we could requ=
ire users to explicitly
pass a flag indicating whether KASAN should be enabled =E2=80=94 this wou=
ld make the function=E2=80=99s intent
clearer and more explicit to the caller.

>=20
>=20Kees, I see you worked on vrealloc annotations, do you happen to know=
?
>
