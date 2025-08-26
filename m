Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FEC3376A5
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208163; cv=none; b=I7cwQZAqqj/g8HbXH5u8g9/pVfaCaGurWDPMsQTBPUGzsGjNeC76+bKMlIub2JsAGElnWpY4Q+DnA8gfEcC5uUqdCczv25vCu0MXu2fS8FTIeuWfO6WHzKCuz1sUzaReYJOT+sJy02jdR0l+J6lbAF2bC/zwedHVIWx88jsQOCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208163; c=relaxed/simple;
	bh=6T0KcYdH4RxINYAieEJhj7zzCRwYEJoTSFVKSGxD7gQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:In-Reply-To:
	 Content-Type:References; b=rwAgjwQ4kVM5zFh0lf/jj/RjLtcPTncKobCXRA0aADbgJyGrDpOvrYeNt86c9pD+SUcJCP0qiI+NHyjdyTWSDGRPC9rlb1QJkTcGU0aYnsL26LHG6x9IZJCqJLbDAq7UJvkPr4CjuoKIk6n2e0OuDhat9Ka25CuAM95vC1AOSq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ogu0dJnV; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ogu0dJnV"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250826113552euoutp0204311248eea7e23f1486280101587af5~fTgKiCeqg2154721547euoutp02U
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 11:35:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250826113552euoutp0204311248eea7e23f1486280101587af5~fTgKiCeqg2154721547euoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756208152;
	bh=JFB5i0y7waDzFihaMge727W1/VaPFefI4bheKhLk7sY=;
	h=Date:Subject:To:From:In-Reply-To:References:From;
	b=Ogu0dJnVYRKlcQrMBehujn0oIomsvugo7Xw4NBPi3WIpg8lMeCdyVL01gbgBs6Zp/
	 JxsGZqpIokrOW1/k9H74y/D2AooKu2kHETIfTbIRhcJkdI/Z3OuCaMlekYI2XT9cej
	 Zjwe61P2JrY8ST5abgasxqHUWFf+BnVUPpcXTA6E=
Received: from eucas1p1.samsung.com (unknown [182.198.248.176]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250826113552eucas1p2993d3037f6d7321d908eb3535b53c0c9~fTgKE-Xnf3194231942eucas1p2M;
	Tue, 26 Aug 2025 11:35:52 +0000 (GMT)
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250826113552eucas1p195363e91b9c880e0ab21d9d03c428366~fTgJ2F0IB2820328203eucas1p1q;
	Tue, 26 Aug 2025 11:35:52 +0000 (GMT)
Received: from CAMSPWEXC02.scsc.local (unknown [106.1.227.4]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250826113552eusmtip1891516adaaf856f1904228e93ef96af8~fTgJx7suf2062620626eusmtip1J;
	Tue, 26 Aug 2025 11:35:52 +0000 (GMT)
Received: from [106.110.32.110] (106.110.32.110) by CAMSPWEXC02.scsc.local
	(106.1.227.4) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Tue, 26 Aug
	2025 12:35:51 +0100
Message-ID: <e6040df9-f64e-4f2e-a782-1815fa34be81@samsung.com>
Date: Tue, 26 Aug 2025 13:35:50 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [obsolete] iomap-use-largest_zero_folio-in-iomap_dio_zero.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<sfr@canb.auug.org.au>, <mcgrof@kernel.org>, <hch@infradead.org>,
	<djwong@kernel.org>, <brauner@kernel.org>, <andrealmeid@igalia.com>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20250819202148.BCF22C113D0@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSPWEXC02.scsc.local (106.1.227.4) To
	CAMSPWEXC02.scsc.local (106.1.227.4)
X-CMS-MailID: 20250826113552eucas1p195363e91b9c880e0ab21d9d03c428366
X-Msg-Generator: CA
X-RootMTR: 20250819202154eucas1p19b0993379130fe65ae3d9bbb0c2d617a
X-EPHeader: CA
cpgsPolicy: EUCPGSC10-065,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250819202154eucas1p19b0993379130fe65ae3d9bbb0c2d617a
References: <CGME20250819202154eucas1p19b0993379130fe65ae3d9bbb0c2d617a@eucas1p1.samsung.com>
	<20250819202148.BCF22C113D0@smtp.kernel.org>

Hi Andrew,
   I see that the patch has been dropped in both the trees. Will you 
pick this up again later? :)

--
Pankaj

On 19/08/2025 22:21, Andrew Morton wrote:
> 
> The quilt patch titled
>       Subject: iomap: use largest_zero_folio() in iomap_dio_zero()
> has been removed from the -mm tree.  Its filename was
>       iomap-use-largest_zero_folio-in-iomap_dio_zero.patch
> 
> This patch was dropped because it is obsolete
> 
> ------------------------------------------------------
> From: Pankaj Raghav <p.raghav@samsung.com>
> Subject: iomap: use largest_zero_folio() in iomap_dio_zero()
> Date: Thu, 14 Aug 2025 16:21:37 +0200
> 
> iomap_dio_zero() uses a custom allocated memory of zeroes for padding
> zeroes.  This was a temporary solution until there was a way to request a
> zero folio that was greater than the PAGE_SIZE.
> 
> Use largest_zero_folio() function instead of using the custom allocated
> memory of zeroes.  There is no guarantee from largest_zero_folio()
> function that it will always return a PMD sized folio.  Adapt the code so
> that it can also work if largest_zero_folio() returns a ZERO_PAGE.
> 
> Link: https://lkml.kernel.org/r/20250814142137.45469-1-kernel@pankajraghav.com
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Cc: Andre Almeida <andrealmeid@igalia.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Luis Chamberalin <mcgrof@kernel.org>
> Cc: Stehen Rothwell <sfr@canb.auug.org.au>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   fs/iomap/direct-io.c |   38 +++++++++++++++-----------------------
>   1 file changed, 15 insertions(+), 23 deletions(-)
> 
> --- a/fs/iomap/direct-io.c~iomap-use-largest_zero_folio-in-iomap_dio_zero
> +++ a/fs/iomap/direct-io.c
> @@ -24,13 +24,6 @@
>   #define IOMAP_DIO_WRITE		(1U << 30)
>   #define IOMAP_DIO_DIRTY		(1U << 31)
>   
> -/*
> - * Used for sub block zeroing in iomap_dio_zero()
> - */
> -#define IOMAP_ZERO_PAGE_SIZE (SZ_64K)
> -#define IOMAP_ZERO_PAGE_ORDER (get_order(IOMAP_ZERO_PAGE_SIZE))
> -static struct page *zero_page;
> -
>   struct iomap_dio {
>   	struct kiocb		*iocb;
>   	const struct iomap_dio_ops *dops;
> @@ -285,24 +278,35 @@ static int iomap_dio_zero(const struct i
>   {
>   	struct inode *inode = file_inode(dio->iocb->ki_filp);
>   	struct bio *bio;
> +	struct folio *zero_folio = largest_zero_folio();
> +	int nr_vecs = max(1, i_blocksize(inode) / folio_size(zero_folio));
>   
>   	if (!len)
>   		return 0;
> +
>   	/*
> -	 * Max block size supported is 64k
> +	 * This limit shall never be reached as most filesystems have a
> +	 * maximum blocksize of 64k.
>   	 */
> -	if (WARN_ON_ONCE(len > IOMAP_ZERO_PAGE_SIZE))
> +	if (WARN_ON_ONCE(nr_vecs > BIO_MAX_VECS))
>   		return -EINVAL;
>   
> -	bio = iomap_dio_alloc_bio(iter, dio, 1, REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
> +	bio = iomap_dio_alloc_bio(iter, dio, nr_vecs,
> +				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
>   	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
>   				  GFP_KERNEL);
>   	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
>   	bio->bi_private = dio;
>   	bio->bi_end_io = iomap_dio_bio_end_io;
>   
> -	__bio_add_page(bio, zero_page, len, 0);
> +	while (len > 0) {
> +		unsigned int io_len = min(len, folio_size(zero_folio));
> +
> +		bio_add_folio_nofail(bio, zero_folio, io_len, 0);
> +		len -= io_len;
> +	}
>   	iomap_dio_submit_bio(iter, dio, bio, pos);
> +
>   	return 0;
>   }
>   
> @@ -822,15 +826,3 @@ iomap_dio_rw(struct kiocb *iocb, struct
>   	return iomap_dio_complete(dio);
>   }
>   EXPORT_SYMBOL_GPL(iomap_dio_rw);
> -
> -static int __init iomap_dio_init(void)
> -{
> -	zero_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
> -				IOMAP_ZERO_PAGE_ORDER);
> -
> -	if (!zero_page)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> -fs_initcall(iomap_dio_init);
> _
> 
> Patches currently in -mm which might be from p.raghav@samsung.com are
> 
> mm-rename-huge_zero_page-to-huge_zero_folio.patch
> mm-rename-mmf_huge_zero_page-to-mmf_huge_zero_folio.patch
> mm-add-persistent-huge-zero-folio.patch
> mm-add-largest_zero_folio-routine.patch
> block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch
> 

