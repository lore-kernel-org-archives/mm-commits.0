Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA11A1DACA1
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 03:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755920139; cv=none; b=Vu/3meQ8v+8LkdMEARS0FqgiNtKVnKxp2/ewxwuICTExOGt0wh6lPp2+gaGXlBk6bd63Vxkz8nVQoBWvieqraOT16OAG/T/ldsidFY2Jf6EJF9LlLGICTaT/zhdamt/bxfJ6PK7HKIeJIubPOq5dc3y6mNVdlRQji/JIr16aK+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755920139; c=relaxed/simple;
	bh=QnQZzZuXEPd2iynBdku6mFUYp8GVVLCKISPS7iHBUQA=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=OqvrKYpW9KjyqDHyp8bOCDrhPMnhfUCGf7wExkm9FQf0kelqS9xqb1/Rg4BfzFXhIAnE/xhLyoh8351zqlION7SzW40LV+OQaO/obn6xWPE45upYcpwLsq6wpTTdh4vwTN4LSiB8SJuKEdQxC0K7X23CYx0CxPPQRSfpnK2hTMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciSbrScZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciSbrScZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294E3C4CEED;
	Sat, 23 Aug 2025 03:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755920138;
	bh=QnQZzZuXEPd2iynBdku6mFUYp8GVVLCKISPS7iHBUQA=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=ciSbrScZRwIoDF9siCx76GRQeBz8ygu25A7k6lgi9mDAa+cuGsMo0DStZWSok/8AO
	 JSS0/6gjOytV+0ceOEWCUAnqp8Yn6dOiAy/wD6SgG4MIyGkYbRSoDHxEvBRgVtVNZ3
	 rFdgwFXRpuxvwn/AKxgdH270lNaN3SspP50tJP58=
Date: Fri, 22 Aug 2025 20:35:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mm-commits@vger.kernel.org, martin.petersen@oracle.com,
 bostroesser@gmail.com
Subject: Re: [withdrawn]
 drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch
 removed from -mm tree
Message-Id: <20250822203537.9b496fe27cae69cf8991fbd8@linux-foundation.org>
In-Reply-To: <20250823032932.1BB97C4CEED@smtp.kernel.org>
References: <20250823032932.1BB97C4CEED@smtp.kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Aug 2025 20:29:31 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The quilt patch titled
>      Subject: drivers/target/target_core_user.c: use PAGES_TO_MB and MB_TO_PAGES
> has been removed from the -mm tree.  Its filename was
>      drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch
> 
> This patch was dropped because it was withdrawn
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/target/target_core_user.c: use PAGES_TO_MB and MB_TO_PAGES
> Date: Fri Aug 22 08:07:35 PM PDT 2025
> 
> Replace the custom TCMU_MBS_TO_PAGES and TCMU_PAGES_TO_MBS with the new
> system-wide MB_TO_PAGES and PAGES_TO_MB.
> 
> Cc: Bodo Stroesser <bostroesser@gmail.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/target/target_core_user.c |   30 +++++++++++++---------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> --- a/drivers/target/target_core_user.c~drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages
> +++ a/drivers/target/target_core_user.c
> @@ -15,6 +15,7 @@
>  #include <linux/uio_driver.h>
>  #include <linux/xarray.h>
>  #include <linux/stringify.h>
> +#include <linux/mm.h>
>  #include <linux/bitops.h>
>  #include <linux/highmem.h>
>  #include <linux/configfs.h>
> @@ -74,9 +75,6 @@
>  #define DATA_PAGES_PER_BLK_DEF 1
>  #define DATA_AREA_PAGES_DEF (256 * 1024)
>  
> -#define TCMU_MBS_TO_PAGES(_mbs) ((size_t)_mbs << (20 - PAGE_SHIFT))
> -#define TCMU_PAGES_TO_MBS(_pages) (_pages >> (20 - PAGE_SHIFT))

Bah, the size_t cast turned out to be important.  Please add to the
tail of your TODO list ;)

