Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3014724B3B
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 22:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705444094; cv=fail; b=RcO5CiBJEazF/5VmqYslnC0cTObLmaBrKkX0y1pAtX6YehAdMUwBej6otzM9jmHnQ0fg/1qlGAN5qSk2Q1y6NTinAfQ+jSyLorzgEvUrGdoLGE5bSeVpdEIgra+uWyDcjTeSI+u6y2kJNj6lYYh9Sq/BO0mz3rR2OU1fJg5pjkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705444094; c=relaxed/simple;
	bh=WDjYtxD0SHgLR3PfqBTxKjJPQ4Be/zlXaWPIDtFRFyg=;
	h=ARC-Message-Signature:ARC-Authentication-Results:DKIM-Signature:
	 Received:Received:From:To:Cc:Subject:Date:X-Mailer:Message-ID:
	 In-Reply-To:References:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped; b=rsLsojqaF6EAHTVb9/vzNrzTqJ+r+lt/HcWBP4CvTFD1kBgjHNDxLyim+nWnL2rCX4G54GDPR/Vis6muTtcw32iY1bku54nxer+xiVzfk/q1fXFgSG3V/6ekyoq1UvKclZsWtg0qGpKisE9/puwwgoyB0cVn9an55hOaEWywMds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uNFIZo1E; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uNFIZo1E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V00lHQ9xjh20LmY8fxjM1EVCEkzGmQJ0tTsgv47/YHp6i845zDSdfenBlRKZNQ9mJqKzwBbiILYnGv42K2JTZZiz81gtUDAJLvOfHpxO9BELc8ZByLUdC94hlCacfiLvvIUVxAzqI7DkA1Bl3DrWUJNaMIcq3sxLHO6VXEHr2Z1MAK/cyoqq6wg02O8Hd9hyJMncxT7rByM2n/RLIK1M9Fg9/sSl+x71n0m/hRXAPkdl0V27FEIxfPhVyVGzhj/6ZzezkndmoU6IQpKTvjG1z6kcJCbBOzPTIQTUj0m87qmn58akOLqSvvcybUpqawb07MehGn9AuoRN+AISCrq9gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFvc/HRbEpOV09MdJ9V0Vf2LXQfdG1e3gtW5YT7qOxc=;
 b=e0BOt3ItexEAhPPgACSf8iOdxjMjgFBRJu8RhFv32cgEPSMQ3R1oLATyrg0g1+jmNnj/JeX0jvhYA9UN+U8Ghe7Nia/rVEOP3NSPEusvsVLG2zYlYUfxVR+KJowQh3Pqw5gZLyPgJgu2hdEPXPKJzaLI4rkhL75Xie0Pwl07osaYZlWJEJtfj5MMALKoTEKM302H0vzGAeY50CbBOi3gj54JWds+j6sNPifVZVA6IuZNtU6DEZ++vVxQxXAu06cBLe2O+8QsxM0NuzrCAM6P/rTeM6SDiaeSGDup2LzZ9455ohRyShrvxaUedHFV59I8t2Bo1jPcpoYmCYkHp921gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFvc/HRbEpOV09MdJ9V0Vf2LXQfdG1e3gtW5YT7qOxc=;
 b=uNFIZo1EC41ezc7pKGVph9VU9v6pZxQU3o2UhzVJa858US/J43dh8nYa71avA9GRy9dI0Vjmx1BtopYcj3qY8O/lpGlwxX0VssONRfJjlfToBFatNosntjRJP61lEHkRSV6HpLiY3+keHkbaJXZbs2GevQhXXQPkS+H2/tvY7y6kSn8tbOHXBqUpbY/1Ze9mvImJ6IRHNL7/KRlDgJjOLq6BpTNj58XxhaVL8ak84Nku1yVdCH+TmOUsjcfBVtJsfW2fx4mQkjQ6eVq2mf7oG7sFkB+Y+88ggCkrASVInTiTHPM7CYTeFxU1jB5ZYvcGecUJ9haVYc37QdqHvddcaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7181.23; Tue, 16 Jan 2024 22:28:10 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::99b6:1e06:1e8b:4324]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::99b6:1e06:1e8b:4324%5]) with mapi id 15.20.7181.020; Tue, 16 Jan 2024
 22:28:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 tglx@linutronix.de, ming.lei@redhat.com, linux@rasmusvillemoes.dk,
 andriy.shevchenko@linux.intel.com
Subject: Re: + lib-group_cpus-rework-group_cpus_evenly.patch added to
 mm-nonmm-unstable branch
Date: Tue, 16 Jan 2024 17:28:07 -0500
X-Mailer: MailMate (1.14r6018)
Message-ID: <928AD99F-B86A-4D6F-A86F-557567FB422E@nvidia.com>
In-Reply-To: <ZZ7e3xbIKfVa3yqd@yury-ThinkPad>
References: <20240110160755.3E20BC433C7@smtp.kernel.org>
 <ZZ7e3xbIKfVa3yqd@yury-ThinkPad>
Content-Type: multipart/signed;
 boundary="=_MailMate_8026F3A7-842F-41FD-B967-3DA727DE4060_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: MN2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:23a::18) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB5744:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: b45ccc3e-7d0e-41af-c9af-08dc16e26b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yuYeHWJlOmUBNkvtFmPhZ8Rs5BL01nH+RM9wZfvlRzbHJ9HITxfUbyLtPn3QE8vNQ0yvHLEP71egvUUscJluPsLLlTCPOqO/UyjhKmXBsyPVNugpNHNrBiephMoGe713omIc0bFq1L1mqD/JvcQyW55bwwY6ou5pw94H4UCDi0jsD15BqJ19LVDqHeF3CujMNHTDnb/7UjQqe4h/0Ivy1yfzJ+OG0vGSGNCCMbATpisuLmB/DkQFnjonmYH3JrED5ulzpq/JJ81cBhYd0qF6gIOD16ioGponabylsZPMjypiEb6IIQLxAJAqsYWdWwXKJIyxhVRwRTVg0AjWBytmP6GBORr12Cmw9tBO4iP4TX1hJ7g5TZ0WDJevbu34hpbraqlJJ+ucsRqFTQUVlK1GYA7XseRbp5QgY0utkUMBwthuuNoTJq6nzijHj/nU6ozNwEGZbTztEzhnDR4NMvJmBXbOwAp6y7v9dX9IzldvqZzDbwlz1+l6b4rsNOWIsPX2tmodLnmKRJqV7pfc/9h4hkuLEQcnowEosD5moLQ1jc2Z7lT8HF8Yu7XNfv1F68HMnWUOjGo4IS4kVZD5RsjYmW2Inr+GO3bdl/GlxLDEFmKBBxwNOa08Ec9P4z4de4uFbezc/58QT1UEWMB1bwgIsMTkHPvBOgAQZj8akJ3GPlImkuwkElBgprkO9uUPbwSpXWW2Wo3m7FeV5IVs6vfSPw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(366004)(396003)(136003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(26005)(478600001)(33656002)(6666004)(2616005)(53546011)(6506007)(6512007)(8936002)(6916009)(36756003)(966005)(66556008)(8676002)(66946007)(66476007)(6486002)(38100700002)(86362001)(4326008)(316002)(83380400001)(2906002)(235185007)(5660300002)(41300700001)(66899024)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uMgpitTvxKS0QtznbxtA7GYlfLtXSqTxvE9xEtd9A6yHzQyca7czPNbZLaML?=
 =?us-ascii?Q?flT+fYALjmuZUrLTRtK+scq9oMpBpo8PJ7eaVuGsolj3edSqreODPXcg+6Xu?=
 =?us-ascii?Q?GVlZTCg3qHJ4t7TSYZv92vItQqwXlaASz3SzqjJBUCE6STHaPPCGbMAzYBtC?=
 =?us-ascii?Q?Mk6IL1a7kBb1gcYRKG1GM4grx/ucQbcE8yHlMvH/jyunIAPpbUwt63F8ZtYP?=
 =?us-ascii?Q?a+16DPiQWfnb41sQg7BRec6QCj1EQ2wREzM7WSOg00bykGU3UWJqkT3SzPFs?=
 =?us-ascii?Q?bgMQDfCw9sASWbP5/lhdzPqPTZoaas+U5GzLfNfwIsD7CvqaJ3N/NknJl1dB?=
 =?us-ascii?Q?c5l2KwymlBxx1x9TQVKi7dsQRv+P+mfwq25NcAMjAzoRILqzEUxEu33c+Lby?=
 =?us-ascii?Q?QlbZJxv2l0Fs9gmnAU7zvaI5zZUjAC+5PwyU7iQb/skUO1aFqPi9wXYk9T2y?=
 =?us-ascii?Q?syE+1gyPeIEBiw8P3x5MfkzJgj9pU4xMdJ74TdYqgEjbTtqGqGzyMQzN9BBU?=
 =?us-ascii?Q?DmPnyRY/5K6kHw8fpOkJ81zrWysFojkpRRjzOFOvKJeKRs+tlSGi99vNYopn?=
 =?us-ascii?Q?s99LDUoHmflWkGna5FEUhAA2XWz5S3QctaMgdshhtDd4rDLrRPGmBXWbw1YF?=
 =?us-ascii?Q?OXDzfA5hLaDOUpFQDiL6ZqSLyuB+XaZuGTraJbBDL6ozbUQaUuU+VFaVVOe+?=
 =?us-ascii?Q?BfyYtM7xR61NKoPaaTIZbv83Zam6voDuyo0Zcjx38pNfT4CLP/233VqID6W5?=
 =?us-ascii?Q?nAgMNL/WvCTkYgutQ9oOFUn9Dutg2dkMkJQNBssF/c2cAtovY/iJo5yOEYWE?=
 =?us-ascii?Q?DrTLWgX+WcvIQgHQYVWnuasmsayxfv1WSxPEO1yMeiGeJC6wwzLvfvj+sNMG?=
 =?us-ascii?Q?Fgn0p/pdSTWYomAc7ZRGjwo4sOn2p5TbxSCNY9SAGnPcecEa/Phrl8w7bSSO?=
 =?us-ascii?Q?qYwbGQgHmsj+DDMMnrerz2j87OCQabWqQOj7QNwTcIKlafXLyF+PW+UAuHBm?=
 =?us-ascii?Q?5WuT/VCxNMPajjjeHVuEM1VQFXkXOhW1szZt75J8QdtPGEYIKLsffgml4fL7?=
 =?us-ascii?Q?uEwCe5e3x7Ov1NlUDqzpfvOI8tjIuQUmdI/EjXG9/1m1oTBiyvdFsMlEg4dj?=
 =?us-ascii?Q?7UvcGnS25QkmWT4zxNGqy3d/18M2UE2EqMeBAe0RdN3bkwUj+ypA3IbBlDh7?=
 =?us-ascii?Q?7jme43iQ2EMJEypxtvyfHUCMqkd2XOkf9xJgB5k5YHLZVuFUzAk/4v+ue09p?=
 =?us-ascii?Q?r6HP8ce7s1t4wPgwwpivHJs/mvSZ9pLyAeNMTXgzhTFMuCHYGyjKcMNK9cCW?=
 =?us-ascii?Q?CknoGI/HtTRT7KyxBLwV3Lw8E7/1kw3L+619CJeU1XGKMkhJSqzhdGriLVTN?=
 =?us-ascii?Q?91mBMYm+vxUwQXsUjvG1ZuWhxZK00/c1ofxkUAad2zM+KMAs36Qiu+ADRwOv?=
 =?us-ascii?Q?fYgxkJkgdtoTIhk7oiGRvTLOjE/K8EwB2w4A8gTnoNnGio3UO/SpVYSH+bFV?=
 =?us-ascii?Q?6CA7BPGrFLN+2linDe8XS5KQYoHk9X5IQfOGR5ilJW8tsWm0BOLjJiPQ09BM?=
 =?us-ascii?Q?9gddLZEsPJL3C0DDSPqvoVkr3N+ZxKKBQzYyftvA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b45ccc3e-7d0e-41af-c9af-08dc16e26b7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 22:28:10.3376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +26nhvDtjsCcq52YWcOdaQxG07iolKD1N5aUXpOBUiCUYc+C3tivwJULjCKX4mlM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056

--=_MailMate_8026F3A7-842F-41FD-B967-3DA727DE4060_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 10 Jan 2024, at 13:15, Yury Norov wrote:

> On Wed, Jan 10, 2024 at 08:07:54AM -0800, Andrew Morton wrote:
>>
>> The patch titled
>>      Subject: lib/group_cpus: rework group_cpus_evenly()
>> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>>      lib-group_cpus-rework-group_cpus_evenly.patch
>>
>> This patch will shortly appear at
>>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tr=
ee/patches/lib-group_cpus-rework-group_cpus_evenly.patch
>>
>> This patch will later appear in the mm-nonmm-unstable branch at
>>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when te=
sting your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Yury Norov <yury.norov@gmail.com>
>> Subject: lib/group_cpus: rework group_cpus_evenly()
>> Date: Thu, 28 Dec 2023 12:09:35 -0800
>>
>> Leverage cleanup machinery and drop most of housekeeping code.
>> Particularly, drop unneeded and erroneously initialized with -ENOMEM
>> variable ret.
>>
>> Link: https://lkml.kernel.org/r/20231228200936.2475595-9-yury.norov@gm=
ail.com
>> Signed-off-by: Yury Norov <yury.norov@gmail.com>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> Hi Andrew,
>
> Thanks for taking this series.
>
> I received a couple of 0-day reports on initialization section of
> the new group_cpus_evenly(), and wanted to send v5 shortly. Below
> is the patch fixing them.
>
> I think it should be fixed at the early stage. So, at your discretion,
> can you either meld the fix into this patch, apply it on top of the
> series, or I can send v5 with everything fixed.
>
> Thanks,
> Yury
>
>
>> From 5349b044f0a9e6a1816b786271c9c632a71edc38 Mon Sep 17 00:00:00 2001=

> From: Yury Norov <yury.norov@gmail.com>
> Date: Wed, 10 Jan 2024 09:46:39 -0800
> Subject: [PATCH] lib/group_cpus: fix initialization section in
>  group_cpus_evenly()
>
> _free() parameters have to be initialized at declaration to avoid
> passing uninitialized pointer to the destructor (unless such a
> parameter is initialized before any possibility of return).
>
> nr_present and nr_others are assigned by __group_cpus_evenly(),
> which may return negative value in case of error. So make it signed.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202312310941.FXBRzn8C-lkp=
@intel.com/
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202401050452.IcgrcQON-lkp@intel.com/
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  lib/group_cpus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> index 3a0db0f51f09..c9c95b21e6c6 100644
> --- a/lib/group_cpus.c
> +++ b/lib/group_cpus.c
> @@ -353,8 +353,8 @@ struct cpumask *group_cpus_evenly(unsigned int numg=
rps)
>  {
>  	cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) =3D alloc=
_node_to_cpumask();
>  	struct cpumask *masks __free(kfree) =3D kcalloc(numgrps, sizeof(*mask=
s), GFP_KERNEL);
> -	cpumask_var_t npresmsk __free(free_cpumask_var);
> -	unsigned int curgrp, nr_present, nr_others;
> +	cpumask_var_t npresmsk __free(free_cpumask_var) =3D NULL;

Hi Yury,

I got invalid initializer error during compilation with CONFIG_CPUMASK_OF=
FSTACK
not set, since cpumask_var_t is "typedef struct cpumask cpumask_var_t[1];=
".

--
Best Regards,
Yan, Zi

--=_MailMate_8026F3A7-842F-41FD-B967-3DA727DE4060_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename=signature.asc
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmWnAvgPHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUBEcP/1I7MaXZLZughARfe1Y3schOqnn0KWAc7ri6
0TpPl0cLUXbivPA8PECxvmUsEdYfE/ctg7LyLOAOS8AYj3QLAiJ3F+vXHBMusT3y
orKKrHj7fZAyLvrjyNsmsVgivIGykV121f0KiUW1njWoHUYzL7Zl+j5BoKKOpJqa
SWoFlpus4t8ha02lo8a0Fn20Q6d1xUoduDqvaX69WgaChLC4vry5Il/G8qLQnaYI
YJ9PX3V3D6pUxanS13YNMBdtIS5pgekwR2YlUq/tA1XGDvDPh/BddSb1zh8IkBJ1
U87YdzGqlP0wW18lMAE9/M4fqjZrg8LnEwYRU7y77ag66fwKKJy/8S8uJEcMRvr6
wC6p6WkH5FBA3Db83k1W/ExMiHZF94QvD4whaWYBIwvyRu7j/3zeC6hVK4spRyju
h+ZUuq/TkoqwTWgsYYJdXFnoV8CPA8ivFk1MVGHfJzCfkQHgKZsxFpAu5RVtRpMQ
yL8m6tTXmQvutCYbtLpMJv+qbLDF1qxBtTA+jKXu0Eqa7kPehOGM4pz/N6xy2QVy
uaVK39hbl5iZWgNHPSJOSR8wshz6iWW5YQrT9TQ54pDLqokyy5sE1iWCkwbPaKob
SUoTmtUSuGCRkISxziAeOoIoeqRv9f3Ho5Ump6Y72cHvK91esrIR41sHpQLIIydw
EH9g9g7W
=cQ4O
-----END PGP SIGNATURE-----

--=_MailMate_8026F3A7-842F-41FD-B967-3DA727DE4060_=--
