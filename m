Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DAB1B87D4
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736790580; cv=none; b=J3iyW4QGVN+5gYLCP5AyPlCl0o0KUIGA1Rlxc0aVm3z76XAA5dul8FBed6srpmPyVb9OqRWhr1mtztGarkyYx3bQItO/2xeBqZjxJViL2b5RXkvpcGNiM42h+f69s60EDdqY+3czjHkqP8ejiaYJIufz5tZ1QVk2qxBXBMDoakY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736790580; c=relaxed/simple;
	bh=44K+kJq7CXglts4k2e77iKg4r7tjTjxo5MTkgMbNP/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ls7Sle5t48ANyZyL5QouUsCUqW//SVwLsCLVIXEz9X2qi1ISMfiNsyp618lCU4OyMAbAK0Hyzt0NCAOhEgBCCYzqTnNna8AS0l143K1vXzWrh4hT7QDSVsusSvEtc7z3bD6kFQ+TjDy/Hc80/QBxqVw0dSmlMxmCA+K4QkvBZng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SzHKUEjw; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzHKUEjw"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4678cce3d60so43940171cf.2
        for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 09:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736790577; x=1737395377; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9A07BpvDHp+kJhkp0gywb2Apdujqix4tRr3XukmigUw=;
        b=SzHKUEjwesoQ4xqbbkGlZ8bIukUe0rTKbIYtLFi701mqq1q6hzkW63zhI5fSGI/6dF
         fSzhQ27KkvhLzabBDxsqjboaKg3x1fLOL/nRUX3Lojkfk6kdvBphPwbSOCaj62wNGpbn
         drCkYgrs9rzNzw8KCSV/vfdAN42tQzwWVXw2R8cwy0npMZEca71mn4fJfBKsCsZ3jH6N
         4MH1MbYTVL59wvV9ghgAXmtMJMJQZnF6WSq6yeEwVbDXLEtb+1fg3bJHFBvRv5XyhQqR
         z6oo5XqIuxHiDpCxPJ5KfEGnZqg4j9z3cHoO9BBQt03Jc6Lj2xaP+663HCsxfgAkrKss
         NDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736790577; x=1737395377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9A07BpvDHp+kJhkp0gywb2Apdujqix4tRr3XukmigUw=;
        b=fmrUtQXgAjoWTg0R6VligMslUCH3JfSUw4OJrBWDf2oDg6CC0ins95fd+FHChKQUoD
         SsVDmFmqX7xLcY3C3bDm/3jLbVaqaHSTOdlC2elLMoETPxPgybmZDTFucAhnXwt0Q9NW
         naxbb1cae2Irq1aFVzK1VpNp0aUAHwsO8bFUBp+qQJ5c8FioEsrAu5ftLgdcNrm8mS7t
         mCJI4r5GDPyP0MuKcYO+UF58d3eWP4ZgyUoyyG6e+R3Ve3Oh6d07LiRf0j3GitzoyZxL
         Mm2gpydor3HEmRiWYYIjBQrkGTkbxutYB/tdPIvzCapKxxqQBK9tJDdOrhLRNs5x+KVz
         6z/Q==
X-Gm-Message-State: AOJu0Yx7fiEBs4YoWlYPufbsqcSPz+Yg9kooZ39ZABaeM0kdruoI3kCM
	FgtvnvHP5TkpInK1IRFEe2yAJ9Rsz+VTdYKSSs/oXei1vl3/HfMWvz40LneJ70yW9y6fSPA08Yt
	9CLaZ/6NQsd1f6Ra3kUogcFugRjE=
X-Gm-Gg: ASbGncsKHrIjnPbJLn6VcIwG5igINvubB+dcTG7TTkZycBxg8H3FQ18wjQDi29aExi6
	6ihgyUOq8BCrCathbXM403oVjatMNWCZOJXzJcaF3k3pq+vcq2adNFg==
X-Google-Smtp-Source: AGHT+IFfuBwyZI5yuAu37ce9uCw1q5wOa1lGiFS1rcxWb0MAoMgVUhhrurEou8wGyiVb1jXcZi+ajqts2rRUB+Jy4Wo=
X-Received: by 2002:a05:622a:110:b0:466:a7d8:fd0c with SMTP id
 d75a77b69052e-46c7102fc6cmr338860931cf.30.1736790577453; Mon, 13 Jan 2025
 09:49:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241214003405.C2EADC4CED0@smtp.kernel.org>
In-Reply-To: <20241214003405.C2EADC4CED0@smtp.kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 13 Jan 2025 09:49:26 -0800
X-Gm-Features: AbW1kvYNmlxVp8r1JXZ7x5WhjUTvih9NZfhmZaePXnyU3aXuVHMTRIk6JuPhztk
Message-ID: <CAJnrk1a0_o=M+3NWRWeVrb_3w8_dwHFUgaCYZg4WNpRKKwnHig@mail.gmail.com>
Subject: Re: + mm-add-as_writeback_indeterminate-mapping-flag.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, shakeel.butt@linux.dev, mszeredi@redhat.com, 
	josef@toxicpanda.com, jefflexu@linux.alibaba.com, bernd.schubert@fastmail.fm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 4:34=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm: add AS_WRITEBACK_INDETERMINATE mapping flag
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-add-as_writeback_indeterminate-mapping-flag.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-add-as_writeback_indeterminate-mapping-flag.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>

Hi Andrew,

After the discussion in [1], I think this patchset needs to be
unmerged from mm-unstable. Could you please remove this patchset from
the tree?


Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/def423f4-fecd-4017-9bcb-74a5dbf0e=
9f5@redhat.com/T/#m9f8343c359c72b70e3205ee606459c1f4e1646f4

> ------------------------------------------------------
> From: Joanne Koong <joannelkoong@gmail.com>
> Subject: mm: add AS_WRITEBACK_INDETERMINATE mapping flag
> Date: Fri, 22 Nov 2024 15:23:55 -0800
>
> Patch series "fuse: remove temp page copies in writeback", v6.
>
> The purpose of this patchset is to help make writeback-cache write
> performance in FUSE filesystems as fast as possible.
>
> In the current FUSE writeback design (see commit 3be5a52b30aa ("fuse:
> support writable mmap"))), a temp page is allocated for every dirty page
> to be written back, the contents of the dirty page are copied over to the
> temp page, and the temp page gets handed to the server to write back.
> This is done so that writeback may be immediately cleared on the dirty
> page, and this in turn is done for two reasons:
>
> a) in order to mitigate the following deadlock scenario that may arise
>    if reclaim waits on writeback on the dirty page to complete (more
>    details can be found in this thread [1]):
>
>    * single-threaded FUSE server is in the middle of handling a request
>      that needs a memory allocation
>    * memory allocation triggers direct reclaim
>    * direct reclaim waits on a folio under writeback
>    * the FUSE server can't write back the folio since it's stuck in
>      direct reclaim
>
> b) in order to unblock internal (eg sync, page compaction) waits on
>    writeback without needing the server to complete writing back to disk,
>    which may take an indeterminate amount of time.
>
> Allocating and copying dirty pages to temp pages is the biggest
> performance bottleneck for FUSE writeback.  This patchset aims to get rid
> of the temp page altogether (which will also allow us to get rid of the
> internal FUSE rb tree that is needed to keep track of writeback status on
> the temp pages).  Benchmarks show approximately a 20% improvement in
> throughput for 4k block-size writes and a 45% improvement for 1M
> block-size writes.
>
> With removing the temp page, writeback state is now only cleared on the
> dirty page after the server has written it back to disk.  This may take a=
n
> indeterminate amount of time.  As well, there is also the possibility of
> malicious or well-intentioned but buggy servers where writeback may in th=
e
> worst case scenario, never complete.  This means that any
> folio_wait_writeback() on a dirty page belonging to a FUSE filesystem
> needs to be carefully audited.
>
> In particular, these are the cases that need to be accounted for:
> * potentially deadlocking in reclaim, as mentioned above
> * potentially stalling sync(2)
> * potentially stalling page migration / compaction
>
> This patchset adds a new mapping flag, AS_WRITEBACK_INDETERMINATE, which
> filesystems may set on its inode mappings to indicate that writeback
> operations may take an indeterminate amount of time to complete.  FUSE
> will set this flag on its mappings.  This patchset adds checks to the
> critical parts of reclaim, sync, and page migration logic where writeback
> may be waited on.
>
> Please note the following:
> * For sync(2), waiting on writeback will be skipped for FUSE, but this ha=
s no
>   effect on existing behavior. Dirty FUSE pages are already not guarantee=
d to
>   be written to disk by the time sync(2) returns (eg writeback is cleared=
 on
>   the dirty page but the server may not have written out the temp page to=
 disk
>   yet). If the caller wishes to ensure the data has actually been synced =
to
>   disk, they should use fsync(2)/fdatasync(2) instead.
> * AS_WRITEBACK_INDETERMINATE does not indicate that the folios should nev=
er be
>   waited on when in writeback. There are some cases where the wait is
>   desirable. For example, for the sync_file_range() syscall, it is fine t=
o
>   wait on the writeback since the caller passes in a fd for the operation=
.
>
> [1] https://lore.kernel.org/linux-kernel/495d2400-1d96-4924-99d3-8b2952e0=
5fc3@linux.alibaba.com/
>
>
> This patch (of 5):
>
> Add a new mapping flag AS_WRITEBACK_INDETERMINATE which filesystems may
> set to indicate that writing back to disk may take an indeterminate amoun=
t
> of time to complete.  Extra caution should be taken when waiting on
> writeback for folios belonging to mappings where this flag is set.
>
> Link: https://lkml.kernel.org/r/20241122232359.429647-1-joannelkoong@gmai=
l.com
> Link: https://lkml.kernel.org/r/20241122232359.429647-2-joannelkoong@gmai=
l.com
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Miklos Szeredi <mszeredi@redhat.com>
> Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
> Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/pagemap.h |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> --- a/include/linux/pagemap.h~mm-add-as_writeback_indeterminate-mapping-f=
lag
> +++ a/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>         AS_STABLE_WRITES =3D 7,   /* must wait for writeback before modif=
ying
>                                    folio contents */
>         AS_INACCESSIBLE =3D 8,    /* Do not attempt direct R/W access to =
the mapping */
> +       AS_WRITEBACK_INDETERMINATE =3D 9, /* Use caution when waiting on =
writeback */
>         /* Bits 16-25 are used for FOLIO_ORDER */
>         AS_FOLIO_ORDER_BITS =3D 5,
>         AS_FOLIO_ORDER_MIN =3D 16,
> @@ -335,6 +336,16 @@ static inline bool mapping_inaccessible(
>         return test_bit(AS_INACCESSIBLE, &mapping->flags);
>  }
>
> +static inline void mapping_set_writeback_indeterminate(struct address_sp=
ace *mapping)
> +{
> +       set_bit(AS_WRITEBACK_INDETERMINATE, &mapping->flags);
> +}
> +
> +static inline bool mapping_writeback_indeterminate(struct address_space =
*mapping)
> +{
> +       return test_bit(AS_WRITEBACK_INDETERMINATE, &mapping->flags);
> +}
> +
>  static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
>  {
>         return mapping->gfp_mask;
> _
>
> Patches currently in -mm which might be from joannelkoong@gmail.com are
>
> mm-add-as_writeback_indeterminate-mapping-flag.patch
> mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-context=
s.patch
> fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-m=
appings.patch
> mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indete=
rminate-mappings.patch
> fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch
>
