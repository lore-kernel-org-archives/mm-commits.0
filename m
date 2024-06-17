Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9551922C7
	for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 10:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718618733; cv=none; b=WwFT6kOXoIUMrJi98WTkAeZSDAumk9kFB0chHa8/7QgT8GPfaAhpRoBbwRir5kB3774kmZkKu3/zOekxKu5hKzZ/oIf61QQZs+MdzcnXnW3DSNpmS6PaBioGGePDDQEHJ7HEZ3gnSe3tTTdf6faDJFIJL7DH14KLvx/e5M65bSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718618733; c=relaxed/simple;
	bh=Cz/D7wrIh7mOIYI8MLHfMsFTkqTpM1rYJTZ2vcTDiyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j4Z4/llvwrzSGYwgAu0LquPHm7VzHVEW8op4iRka+yGYUNFShJfTNgPwygmvhDNOAhU8WmJOUBkaKyQwpucIJmnXMpnEsgdJYIn4dSAnJ3FOzm/rf79eLc6XM8/KVivoBGWc2k2xqr24cpf2nk9sGXI1q7rhlt3v3UGnx/91Zio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lJoCyuft; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJoCyuft"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-80b76c5de79so1194358241.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 03:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718618730; x=1719223530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrfWmaY5Y4YJVQ+uwh+KzA9TAkTG/B9YghQtZhDxOZo=;
        b=lJoCyuftBOdiYi4JJaVP2fsoSqtRE2Xhq/El6n1S5wCcB3KiOjlMDz5QjU529q0R9c
         qLjXoDtTMDHcJnPccN18g8nfpMhY9KIGJ8V5R3TA1GxOKaaxa4sHk5cl9/hu8mUwpYBZ
         BS74IqamdjW5XyqN4wiUlEyfHDf4QoZlaa5mLmJHw5Ai6oSQQS0VBj0OtIv7yhrF30Xx
         pl79Mkv2UKJp4i4+hwnL2Om6pXew02Y7Kkl819+UHX/h4Qu6j8Ew8FxaWvjjQbiPKpyw
         4liCNwbDl/forIjRTvZxIQimMVt1MBlSqK+Rjgoz+GtwHE5ZZXsK1AUPt79W0J+CTboG
         qfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718618730; x=1719223530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrfWmaY5Y4YJVQ+uwh+KzA9TAkTG/B9YghQtZhDxOZo=;
        b=YDTStONDLSD/hNDGWdotxztoLm/Wz12Wug1UfyD56Q5+G+KrLr7U+kUiozUWBSyahf
         T/kwH5XIYYfa3DtyTRbph04C4TYfFLz3FCWbkQD4sUoPfRdWSLtR3551Gs/tPiL1dsIp
         fenS8cnmzIbu8cRkmNpvAE6M+pbub6A4xPoa/cnmTjWVnBTwSeXb5S/6l7mhkZRiYY32
         pktsAZ+/t4Mi8CeibthEr3KJUzjV1OvGp17uI/4qoqEcvLeek041fv7ojmRTLvKybMT8
         xDC7yo53aV7oiWzOhyYYMIeaK3tDyrO3Ykxekb80qQ7cBzYw/zqHI1XxI4mdBRwXIWs+
         v4jg==
X-Gm-Message-State: AOJu0YwJfUYjCyWLy6mtFUCsgqN71fmXSpVfm7cWHOpiV71YI51NSWKG
	SAqNvBlliQPd+ZKHSo5soQ4eEN4dPa6t1AjjCDXvKWaqfmn9QVNMlmZGHDepPBaW8y87G2nW+40
	6bm1kfh67PDrS7cj4mAnVPHLdYEc=
X-Google-Smtp-Source: AGHT+IEbyTrIEfFopunQwTaGX7baW7WVNOwqtNzx2NSW8r2vcUU8hr9CqwhO4QxE2SurLKPmtzEetyJQm8t8dagflOI=
X-Received: by 2002:a05:6102:512a:b0:48d:73d4:8b7e with SMTP id
 ada2fe7eead31-48dae322a1emr10695708137.20.1718618730197; Mon, 17 Jun 2024
 03:05:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240614182431.063F7C2BD10@smtp.kernel.org>
In-Reply-To: <20240614182431.063F7C2BD10@smtp.kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 17 Jun 2024 22:05:19 +1200
Message-ID: <CAGsJ_4y5s1uu-LdkAudKdqE9u=GfHdK4eCdB6yc3b2ea4+_BBQ@mail.gmail.com>
Subject: Re: + nfs-fix-nfs_swap_rw-for-large-folio-swap.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>
Cc: mm-commits@vger.kernel.org, ying.huang@intel.com, v-songbaohua@oppo.com, 
	trondmy@kernel.org, sfrench@samba.org, ryan.roberts@arm.com, 
	hanchuanhua@oppo.com, chrisl@kernel.org, anna@kernel.org, hch@lst.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 15, 2024 at 6:25=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: nfs: fix nfs_swap_rw for large-folio swap
> has been added to the -mm mm-unstable branch.  Its filename is
>      nfs-fix-nfs_swap_rw-for-large-folio-swap.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/nfs-fix-nfs_swap_rw-for-large-folio-swap.patch
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
> ------------------------------------------------------
> From: Christoph Hellwig <hch@lst.de>
> Subject: nfs: fix nfs_swap_rw for large-folio swap
> Date: Fri, 14 Jun 2024 12:03:25 +0200
>
> The series "large folios swap-in: handle refault cases first" will permit
> the MM to swap out larger than page size chunks.  NFS has all code ready
> to handle this, but has a VM_BUG_ON that triggers when this happens.
> Simply remove the VM_BUG_ON to fix this use case.
>
> Link: https://lkml.kernel.org/r/20240614100329.1203579-2-hch@lst.de
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: Anna Schumaker <anna@kernel.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: Trond Myklebust <trondmy@kernel.org>
> Cc: Chuanhua Han <hanchuanhua@oppo.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew, Christoph,

As explained here[1], please hold this patch till the root cause
is confirmed. I don't think "swap out larger than page size" is
the cause. To me, the root cause is more of NeilBrown's
"mm: submit multipage write for SWP_FS_OPS swap-space"
which allows many pages plugged in an array and then unplugged
all together. So, Cc: Neil Brown.

I am going to send v3 with fixes tags once it gets double confirmed.

commit 2282679fb20bf036a714ed49fadd0230c278a203
Author: NeilBrown <neilb@suse.de>
Date:   Mon May 9 18:20:49 2022 -0700

    mm: submit multipage write for SWP_FS_OPS swap-space

    swap_writepage() is given one page at a time, but may be called repeate=
dly
    in succession.

    For block-device swapspace, the blk_plug functionality allows the multi=
ple
    pages to be combined together at lower layers.  That cannot be used for
    SWP_FS_OPS as blk_plug may not exist - it is only active when
    CONFIG_BLOCK=3Dy.  Consequently all swap reads over NFS are single page
    reads.

    With this patch we pass a pointer-to-pointer via the wbc.  swap_writepa=
ge
    can store state between calls - much like the pointer passed explicitly=
 to
    swap_readpage.  After calling swap_writepage() some number of times, th=
e
    state will be passed to swap_write_unplug() which can submit the combin=
ed
    request.

    Link: https://lkml.kernel.org/r/164859778128.29473.5191868522654408537.=
stgit@noble.brown
    Signed-off-by: NeilBrown <neilb@suse.de>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Tested-by: David Howells <dhowells@redhat.com>
    Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Mel Gorman <mgorman@techsingularity.net>
    Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
    Cc: Miaohe Lin <linmiaohe@huawei.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xDkjN0X8ogE9djmu+nDUd_PJcSwr+GV=
H4vUiUAeJskaQ@mail.gmail.com/


> ---
>
>  fs/nfs/direct.c |    2 --
>  1 file changed, 2 deletions(-)
>
> --- a/fs/nfs/direct.c~nfs-fix-nfs_swap_rw-for-large-folio-swap
> +++ a/fs/nfs/direct.c
> @@ -141,8 +141,6 @@ int nfs_swap_rw(struct kiocb *iocb, stru
>  {
>         ssize_t ret;
>
> -       VM_BUG_ON(iov_iter_count(iter) !=3D PAGE_SIZE);
> -
>         if (iov_iter_rw(iter) =3D=3D READ)
>                 ret =3D nfs_file_direct_read(iocb, iter, true);
>         else
> _
>
> Patches currently in -mm which might be from hch@lst.de are
>
> nfs-fix-nfs_swap_rw-for-large-folio-swap.patch
>
>

Thanks
Barry
