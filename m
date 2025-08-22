Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2BB23505F
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 22:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755902273; cv=fail; b=OngYWROfSqQE5UiQBNyf9FYeZsqAgDB9y/1uMFftQf7dt/Z7Q+QNS3b93Rwc097eTDbrxccFXcq6nnJSJBGMjqVYzK2OuDJLGZAZillM+oWd5tvlvvLAc7lPlmEqP8hEczjCA8J2qOscPN8toCJ2AHB4gdUs/SK2E3CpX4EI1wQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755902273; c=relaxed/simple;
	bh=KWh8J5t5QWJ2pcz9bM5kw4G8zIBqrfoU+G4iHRjg6Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S6r97j5AyTJDA9MgwV2xyC4sJNL1jou1A0UmO5rF3TChyhCDZ6zu8koBUFwhgS5zvVTzwBwvlWtl3tBOA0/707PFSGQ2YRuGuq/v2ufYet1kl/Gh2AydH4YgRmbYVRS57RHVzL+baMTJQXH13qdtVuR39t3XB6cz6gbVeOHSv6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SekMgqGx; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SekMgqGx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rg54ZWGEh0dTtUYE1eM1UKS1NOKuzpFDMxk5oXhUUCn8PQDlrIlwHfQYzos8yOPysIOnxx+PxfQ07v0KqLipSsXqUcImhNYDRibs5q3xheqxWensv0Vehthr7E+cWNmb+bJtlAQsbFri2HYjDP5ynP73nONylS+er4FsCnErglnzfGXYxDtbSwtbb3HYl/Uly0zH0QFlIbScdqmtLBJ/CT/fqp9TZUCv+KWbdhebXRUUerDjl47bLRIaexiZJk+nmzwCmA4/EMoySoPhsV0gsW3srNFoEMqs7EDWdSTQ/SFT7T99IgMnUKnTQbr8cQb8qpnP3cEzI3va70kT11+Ekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRlVrz3gReyxeXxaJgIpk9RR7Kl+gU7XN0exCLj6aEo=;
 b=OK7rvWIN9+UIHCkbBOr5d6Ouz7y2ipdpj0uZio+gKsDl1jzqC44/InKV/kdMtUhkY+UPKmIXwf1EUdTt5VzDtmBLZzvNWzIka0EYp1gtk2EkG8LzG0H94ZBfoJ0PJy/V9OIUx4fFVkBMLggfRgmWzLY7rYHJCPDEQ7r306YXUg7fXaAK+kk4luslIr2LvkXcR6UPYAigmu/FwwgvsWAk7Ns1VZhLiNBvPdeery5X7prHXsJCWH5wa4JoKLDba20BhF8TTrgIO4Mk601hAwrBjcKvUoCAnbd8nfNEMZakv8k0up1E6k4Ozy/kUe1uEKV2stsLN2EaqiiBc1RUCLfvIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRlVrz3gReyxeXxaJgIpk9RR7Kl+gU7XN0exCLj6aEo=;
 b=SekMgqGxBE4Lv5+c/mZ5BsST4PP5UUjtmt+8DwmlxynOZUyQVntnzPhk4clFgPSSvGt0RRTg6nCmfW5BjZ0ngmI/NCPxbRHtjBHhiAZ4lQE09AFLqUwFKPWLp23GmRZElXCCNqjFTaf2tzipvmtbDumfb4FjQhpKuaxf48SG8b+STx757MMg0u+HQKJPfoHNrl+4+mApHB5w5YNq8fQntMtbGUcSx84JpBiJ8KuzCJ04z+lq157HyLWRl1joPMqk9Tdf287sibXAURRKF+3H7w90EMY0QktRRnpxL+8vqTI1sovZpBFodkr7DzABnQXVBRBx2Kx6NK8Fl4devkkbhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7803.namprd12.prod.outlook.com (2603:10b6:8:144::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.23; Fri, 22 Aug 2025 22:37:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 22:37:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vgupta@kernel.org, lorenzo.stoakes@oracle.com,
 lkp@intel.com, liuye@kylinos.cn, dev.jain@arm.com, david@redhat.com,
 chrisl@kernel.org
Subject: Re: +
 mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
 added to mm-unstable branch
Date: Fri, 22 Aug 2025 18:37:45 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <2D142A2F-4D76-46C9-9E4F-760F9CFEA6CF@nvidia.com>
In-Reply-To: <20250822220159.7AB3BC4CEED@smtp.kernel.org>
References: <20250822220159.7AB3BC4CEED@smtp.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:208:32a::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7803:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c392595-7643-4a88-07f4-08dde1cc848a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?205440U5boDsemcYs720ikZs8+tyQLycrWIQSsq/FGm/yABioJunIczfelIL?=
 =?us-ascii?Q?DBfU1Ce0fUJYkuDCwVeB9amiJ+tZRmDdDdOeSfQX16+FU2LkunYDz2lWS2bK?=
 =?us-ascii?Q?7LJn/4Qea3LF6X1SzLV8fjTYrS3KeQhC0eeRAMulbBmfK+dAwA5/oFg9Bh+q?=
 =?us-ascii?Q?GZH3VBjuJ6QP9U91bAAf+2KHIyV1TYxjBxX70GXq9zDxrkYH80S/jW3gQFDV?=
 =?us-ascii?Q?Y1+RuP0wKWfy1HmOJGWFYDDg9PXMhykmEEWoVGytRLbw5TByr2ldbQO5/ySq?=
 =?us-ascii?Q?jc+Op+nxOCgTydDI0JLSXVIJZDHgRPlhIaZwPXVMoq4+N/bLymjQhGc0CmbU?=
 =?us-ascii?Q?5GrcH7tXALLPe4KeHOtYK4DCzaQDtn7mW9mSuP/+Wdsx+DVs8qCuNTqDRtVy?=
 =?us-ascii?Q?t3V+owXFNGhI+8SpuCIQGFK0yJhLIr42rKFpiZbNXqBCJTi1j9fsIR++VBzO?=
 =?us-ascii?Q?AQ3GpHOWd54dasAGUYiHwnfwl37wRXhx78VXrKUeaUzJvc4GrNAjc5ApsYD8?=
 =?us-ascii?Q?ivKaWVXxxrVhy2O6MQv6a3U5uP3HLyjJRI4aZj8iqFqbdhxKKZEMWPsJm7XW?=
 =?us-ascii?Q?fGT/vozRA8usoElvtYzYR8a3jeMRPnlNDdgBUv4BPf6by6gNnbQtQqq0YEd7?=
 =?us-ascii?Q?lt5njK5X92puzNzNN97yNmjDPJIOGYJYtWeW5xVzfZjwg2IQ9nQEjCzIw4he?=
 =?us-ascii?Q?WwWT/RnxSZA92pPmvbTgh+eS737ChFNIZxqTFfLficxyZ/fngUuo1iuPlvxi?=
 =?us-ascii?Q?ncYZdw799W9n9cmwxaMpJqJ/E8T66NO8xoh/84cB02nnBOaBD9BVVXYF76CH?=
 =?us-ascii?Q?HYYKl1ZW6bynh6RMdjQSrCIYY/MLcRdLtKIfEDAeQxbWIkVuZyz+x41+ksZm?=
 =?us-ascii?Q?/+x9+WpJ4yCFaQlVrbfeNpjfQiAXH7D4P+XmC9S8wINEJU6TcGuuVyoTGBQj?=
 =?us-ascii?Q?FOcRdoAnowOcU4WpBeBH1dr6ADJJQjB6aYVXbwqW7r6gqaN8g1akIFdcKkg1?=
 =?us-ascii?Q?3qHkZ7XmBY5JiDcXVm/m0Z1jU6IUvuiVejaWTnOg4PSBxli5+N8X/Ds4I9wX?=
 =?us-ascii?Q?D0XMTzgFIGkcY/UL36sKLy3Q44w+XMuBN8SymI7pl2/6jRhO0KTaWJYpyyAS?=
 =?us-ascii?Q?yJRadY40q7slMGcOviqGPo5MGk7jCDLFsSWnzUim7MYntElgWJs0dDPUQqgq?=
 =?us-ascii?Q?QOcV6N/tN9IuokwrBTv1yB6QW87Iz1qgSNSSrCVvHtlE0QfcofeqnqILYRZx?=
 =?us-ascii?Q?Nyzsm0mrINqlDEPSNvJ2rTnxh6N8Gm9EiB+DhaHbB7znU0+TtnYF/buUPsJX?=
 =?us-ascii?Q?brb79BqCLLoVvcYrxJ/Qh5uHWJssJ5arszJaobNFJGqioqqEMiWucBkA3qXm?=
 =?us-ascii?Q?OGgf0Hq8oUeyfe9+T1gfduyCTgJ5ZKYf/eFZO95NxfeUoWuhBXk9E4K9zM8y?=
 =?us-ascii?Q?nrHPNPQA1NY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FXvNZkzDPQmDo0m1i2+XyR0oB2gVJFsmxkKPjB3McSl2bUuqf4FDqiFo28X1?=
 =?us-ascii?Q?HItw9xAdXhAueYhXVsX8/MjStOhTG4PsgYyNgBxkG+lMMvn+n+LuRtxBBCtL?=
 =?us-ascii?Q?Qsi/EqsPD/RBC566vgGOp1ZE9P+rCTq4tMuw2T6sLCXEeujAB8q5D4FmkeJV?=
 =?us-ascii?Q?hZeRj0/XbMYfFXme5pYv4fG5Ka2f7Exhf4CaduZpxxfOos0JPfr8ILLJ8nhi?=
 =?us-ascii?Q?6NrX9j7MbBNkEL3G+Ja5NyKfdjB+pz/EDvktByKYYlJX4RNRZ2Fct/h4q4ZC?=
 =?us-ascii?Q?A0FNptMxLJGUYEFWkRbXOud3vwEeexrFI6wBReV8Q1Oizcj67FTXL1nm5hnM?=
 =?us-ascii?Q?GrCkRuJgGdtp+2cp0VVDuepQ9IjcwOE8S3GqWUFqeCzB+JvNuBXf7I3bCURH?=
 =?us-ascii?Q?NDzn/+t9oPKmTdjp3dHZuXCPN2zZ4pbOaFVRWX8HSSCmxz9635n/7NtFVrdv?=
 =?us-ascii?Q?2/CUoDW5spJ4wWc0gtTCoBl5BG+Hks2eV0MhwmNwanEmmRUl19uRb28QoL1K?=
 =?us-ascii?Q?9wWlGWj/Pv+4DOgYAJwhVfUa1gE1PBS+CwObHWXozX06j/tf69QcsHAeBtxW?=
 =?us-ascii?Q?QpQdqaU06PGTmZ99UflG+ocI9Fdu7XyDvuvEFhI34qyDiiobc9oc6lYbaot3?=
 =?us-ascii?Q?uhQcgNubI/z2inazAwfGgxbP2Ml/dzLMLTudLWmh4ov9e6T5lI/IwMmmSgxI?=
 =?us-ascii?Q?FCFiwP3pOhFRwHW0G8TPrfptu9/iUFgj+520tDl+KxpO4q7/tRpcuMqW2kZA?=
 =?us-ascii?Q?9o8gFb7TQ9+GCtrhLK7ZfMmO9be1sEuOWmTMiXYZW9PBWDBSuayhYjxn4t6c?=
 =?us-ascii?Q?2xHDsi6Cj53bcrN03qDHdW9umQ/w7KLIYXvY99zpgvxdQVuKZXrCmIQSbPsp?=
 =?us-ascii?Q?9E4Gz4J0qSWYTOyc5wKZanMe17ULrTxPrSu0kABv01mC3DDJFbdANF1lymvD?=
 =?us-ascii?Q?Nq5Q5HBqDuA3ozA1bHhY4qPYEPaO5fJlejgbPmklTzgCWQDEAB3hrv+6Sf/M?=
 =?us-ascii?Q?IMz3hAoYNYqqiufBL1PQf9/MaMdlsTWbFwhtWXo5LjGgyI9k+85UdIve0UmP?=
 =?us-ascii?Q?PR9BdYOmvrWSSzNvoKFxROoTJTF7fKG8fvVXs2zsENxPo2qoJelEUdCxcbls?=
 =?us-ascii?Q?hy0QwNuX/ZNwS3p9q/Yz6IhfqahifriR5JccHQfz1cnBxwSU2zLT936Nh+LC?=
 =?us-ascii?Q?PrV7ndJTs1XDHEo3sJiYBd+5C17mPO9oIEZXkSnMXa0Oz2Qk0AZxcqljYumD?=
 =?us-ascii?Q?MN0JvKqtGtkINjAsiV//tjCF8srJH3+UxraXiVcfpZRCp1EqsvzA/iuFvrBx?=
 =?us-ascii?Q?iKqUMTXeWBHUVbrNushEv2wVq3odjvoUHFGsDka3dngg+0Pb7yYQn57VTmdw?=
 =?us-ascii?Q?sTNKYN7oL7kMve2+fONVqHxu/8itoDRJtxokLecxQwmTmfsKBDd/PdePp24f?=
 =?us-ascii?Q?+5NUrdyvkBQbijG93mxb7WfLFxzAlanvrrUniGPZDI9DD9c3HeETikHRzcla?=
 =?us-ascii?Q?kAF4/aFpwZcCIkzFQIQRZ8vW1Jaagmys0hvUUNyfbSRvMTmuU/M9UjLCYVyQ?=
 =?us-ascii?Q?UKzLRKlrkSpM8yDcdcyItPS3eM9MB6lGfg0DqaXZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c392595-7643-4a88-07f4-08dde1cc848a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 22:37:47.0873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isfWhLGPY9xGKRFlumJe4dyF0CvktzvmLIfZLRVklAQwfT1urjQ5d5WydMR+fy/V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7803

On 22 Aug 2025, at 18:01, Andrew Morton wrote:

> The patch titled
>      Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-=
conversion-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversio=
n-fix.patch
>
> This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tre=
e/patches/mm-replace-20-page_shift-with-common-macros-for-pages-mb-conver=
sion-fix.patch
>
> This patch will later appear in the mm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when tes=
ting your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conve=
rsion-fix
> Date: Fri Aug 22 02:54:15 PM PDT 2025
>
> add system-wide PAGES_TO_KB/PAGES_FROM_KB to mm.h, remove arc private
> versions
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lkml.kernel.org/r/202508230539.pnO97SIj-lkp@intel.com
> Cc: Vineet Gupta <vgupta@kernel.org>
> Cc: Ye Liu <liuye@kylinos.cn>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Chris Li <chrisl@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/arc/include/asm/arcregs.h |    4 ++--
>  include/linux/mm.h             |    2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> --- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-comm=
on-macros-for-pages-mb-conversion-fix
> +++ a/arch/arc/include/asm/arcregs.h
> @@ -146,13 +146,13 @@
>
>  #ifndef __ASSEMBLER__
>
> +#include <linux/mm.h>
> +
>  #include <soc/arc/arc_aux.h>
>
>  /* Helpers */
>  #define TO_KB(bytes)		((bytes) >> 10)
>  #define TO_MB(bytes)		(TO_KB(bytes) >> 10)
> -#define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
> -#define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
>
>
>  /*
> --- a/include/linux/mm.h~mm-replace-20-page_shift-with-common-macros-fo=
r-pages-mb-conversion-fix
> +++ a/include/linux/mm.h
> @@ -75,6 +75,8 @@ extern void * high_memory;
>   * PAGE_SHIFT is the shift for page size (e.g., 12 for 4KB pages)
>   * So (20 - PAGE_SHIFT) converts between pages and MB
>   */
> +#define PAGES_TO_KB(pages) ((pages) >> (10 - PAGE_SHIFT))
> +#define KB_TO_PAGES(kb)    ((kb) << (10 - PAGE_SHIFT))

Left shift and right shift with a negative value. Aren't they undefined
behaviors?


>  #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
>  #define MB_TO_PAGES(mb)    ((mb) << (20 - PAGE_SHIFT))
>
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org =
are
>
> mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix=
=2Epatch
> mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-f=
ix.patch
> mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
> memcg-optimize-exit-to-user-space-fix.patch
> lib-sys_info-handle-sys_info_mask=3D=3D0-case-fix.patch


--
Best Regards,
Yan, Zi
