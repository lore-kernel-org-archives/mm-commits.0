Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2096.outbound.protection.outlook.com [40.107.215.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DBB208DD
	for <mm-commits@vger.kernel.org>; Thu,  4 Jan 2024 10:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="N4/5IPV4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOghsuqaq9bspVEqajw7P3kKhDA2MxicTKECNjNvYaoJ+WNTojIchK4TCihg2cJ/z5BlFTXPBDx6FAV9E+VN83cKkNh1cxg0cMZg7RATT/wBk5K5RyK8zE+38QVcVC3EIiSx1IEMVkKfuytkgvNtzMH4+8XZLC2pyK9YW6bxiAcYmVxbH2r8S/Ap4TjAQPhDY+TMXkAVVJp+89ggyxhvJnChnIn1mGot2mM5eFb5cSLUyIZ1VV4ylZjDZ9VYJkvRBh06rgeU8yQESts7Lz86dIRDOsHWyvRlDhiLF9qOBFntzqu1qqG5SSjA8SmH8/IBS+HvqlvPS37/p+MMMphu6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zsVe3UP4UgK9uHn33EMZpTNhMYGychcd080bxCe9C00=;
 b=IT1tebaRl37xubuGrHNXixE7/f56tzE6lJ0BKkUmSVfpkGtYJKEY82pdBvOH8GFsP/PA6O8w+tP4titgEYRFl+vFfWv/RJoA8/bzfvq4JhDiPvzHPiwNG19ilY7FCgKu4xjtSm85jCAje+RNb81bXwpsr+bsrlRmqXu+r0PM18haW9gcZmO+HiSw0UfTfTkQbKtIkT7TblCMX/NjNeGbLWpQhvqtnKwctN37uAwlZrzn0K+9qO40ALclFp0l5V9FKUYKLRgvY4O5dPlbNu6HF/EK8wtGm8ureglHrKLtkIzNOBd9OtS2ZpD1tO6uoBFLdz8XahMoOF3GUPveNgfTvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsVe3UP4UgK9uHn33EMZpTNhMYGychcd080bxCe9C00=;
 b=N4/5IPV4AMspXJw/OCxas9K4YrjcTh6YaOB6/BwGT65KJL4dNPpqUy//JGk/3r3/BgGsZdAfZvt4ATtmCgzH+5+/EUFzJHA58kJbq2hGbLwLoWicjq1+3d3c7Z407fVXaTSjaKAKflr4PTE4tkpAXyVlUNqCuB3d+O5MhlDDz1Ez3tdAasB/0eWZrEB/HIsUirQTPuHlL4URiZ49quKE7nFQjearkmu9jTsWzIoYdF/rIFsHT4KH5w1WOA3krsMCEKLrS/lfiIznib9OGaNpXKMhf3hicpYKfiHIZQEflZxU8FSke1He4WDb3UPObGuxUR6xIlxujdcEjfRflVVRug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com (2603:1096:400:21::8)
 by SEZPR06MB6841.apcprd06.prod.outlook.com (2603:1096:101:191::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.14; Thu, 4 Jan
 2024 10:02:14 +0000
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5]) by TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5%7]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 10:02:13 +0000
From: Bixuan Cui <cuibixuan@vivo.com>
To: akpm@linux-foundation.org,
	mm-commits@vger.kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com
Cc: opensource.kernel@vivo.com,
	cuibixuan@vivo.com
Subject: [PATCH -next v5 0/2] Make memory reclamation measurable
Date: Thu,  4 Jan 2024 02:01:43 -0800
Message-Id: <20240104100145.3855-1-cuibixuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0091.apcprd02.prod.outlook.com
 (2603:1096:4:90::31) To TYZPR06MB4045.apcprd06.prod.outlook.com
 (2603:1096:400:21::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB4045:EE_|SEZPR06MB6841:EE_
X-MS-Office365-Filtering-Correlation-Id: d3e954f5-4622-43a8-a32e-08dc0d0c396b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wtSRqfnmzqJkztLgn33r8idV1gWV7BTk7jffed4RSKJsps351F5YyMoE6chXaqzDM2+IxhBRZCmt+GEaX9XFJKN/FOzG4KTF7PU7Z3TF/DpQr5Muy8K07k0+8u7g5xMhirXfbJNqh9AH8QAFJUdQln0E/ad3kNPaAAyrpSyLUVOzlCytvgjMc20b/YM2Bvuz55By3HubfgvvzvXU+sIbuuzxHZIDJAgXczTYdkF0wE0RKn7RvB/WbMesgIe5fkmStRNYADrfpcikFqpSCR+3GAInqWLXc1rJQarXEvo6PIrFJdq2o172dWiPUR7faifvQhLgKRJr4gwvzElEFbACCt+0XE8vokav/5+Zq7ZI5cW1C9OHMm2ADxBzpEyqH7R46U0Vii+BT7PsQBB8NVWbKd1bevA23HGr3oKyOuXBpq1WQpZvoCL5gQjY18e7zcHf/ulUPNYyBV8OREgJOvurWZzUFiftisI2VZUPttQyOA/SSLGTBUCLb3JBSq9+GUG9DnZscHwuqo0z/Zd+UR3mVUNNwgSUutSHdLDtBzirNwkg7otHVss9bqz4QsV31WkBStLn5hbXhK2EwFjrgT4iSoJw/+ISPAktALVFTvyfe0IDvQN1zVUShTLw2T0lbZ6b
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4045.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(39860400002)(346002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(316002)(66946007)(66556008)(66476007)(6486002)(41300700001)(5660300002)(478600001)(86362001)(38100700002)(6666004)(52116002)(1076003)(26005)(2616005)(107886003)(4326008)(8936002)(2906002)(8676002)(38350700005)(6512007)(83380400001)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ObNHK842IQl0z4HwuT4qEhjPTYHlkXkRXZzUBdiDm68CRIvEQpxHuDCZvZ+v?=
 =?us-ascii?Q?E+//hyg/TjioQBa8/zYqrh93NOITbkzthrrCAJiyc0X2SKLbXUAkoxdpiqUZ?=
 =?us-ascii?Q?tjtHQq/nxNcMdPJUmr8VR0KmYk61NXIvHe1B7STmUIvY9co9w8zAk3Emy/pN?=
 =?us-ascii?Q?X4CVSp5RGF2vc/K/mXRhvMHWrUgyvhxGRLKJW1Yz0SfMELkP3BiPCnu7ZuPL?=
 =?us-ascii?Q?AVHs7wROKWN0T7JT7hyDSaOv31ceojA4RZermEdomWj6dQpX+5VkBAjBhdZA?=
 =?us-ascii?Q?my5GK7KOWug7VZfin6y+ISkllvuEA1y0i+Fo9U9TgD/BIBSFngs8TzJEc6QJ?=
 =?us-ascii?Q?McZgbxavmGSu5nQF3Qr7F8suK0pd+mrTHQyXbkf+yDOK4e+zxCJBcvvnaASd?=
 =?us-ascii?Q?GmO/D56xStF/SSoE862MuN3tlN2IQrJgz1MZZqrurce5c57UQpdmKt6/k3NH?=
 =?us-ascii?Q?mb90BmE4ki5M4Ha/SQD0puA3ZTPG6VWudkg1uSQPNDDFyMg7YhzbFOW5Voy9?=
 =?us-ascii?Q?wzfOtqVEi1YN3c3FlKW2kUlt6D3BB+uJ2XEcOO++6OZN7hHbrqDI4pGJ6Pa3?=
 =?us-ascii?Q?gLE3c4rGHi+MdLK1bUjED/zS4J0UotZvwkiX5H+OXU8nWpBLAp8MJgFki8kE?=
 =?us-ascii?Q?dDkzy2XPbshShSZnQz4B8k6GeWjD+O5w/O+V6OZnw1Q0TdbjST+Amxl9pYV8?=
 =?us-ascii?Q?1/0pRllUD4ZlkBw0J8N8wjhhMKMir0jksIBZW7n06Ar6JVYJro4f4DpECPwX?=
 =?us-ascii?Q?4QQ4TV0N5wIpmUucbCOkmLB0pTPTP7qztWJ/ORzeBF0DiXhZhc/SZJ3i4rzb?=
 =?us-ascii?Q?E3HJw/wlfUv7SeHZOJYsgm+h1JS1pUPYhXl4lF3iArEQ1Bt9nSPAO6OhkbQt?=
 =?us-ascii?Q?2BZddBmDp9/XvoLYQ0OwVJhcKWtL0hJsdOJ9QQTSi1b2Tg7rXjFlk4QvQAWD?=
 =?us-ascii?Q?MOytrv47ARkvLwg91ihZMNaDZDAaW9nZZ/ynBNclEBas9moGVfPePSzx3vIy?=
 =?us-ascii?Q?dJBtpgpvmwVF8xIp6ReMsYB/r7RCmlqe0P36Up+9MDzOYyS4GReu+V0Ra3fr?=
 =?us-ascii?Q?vJ3NbeZcrIIm19ZqPuQ5YZdfyX2uFhIy+55KT0fX3wNANgQJE34gYntfuYGw?=
 =?us-ascii?Q?8sH0Mu5zUCywiTVdt52s2OVe8XRo7d/S+EeqdrhAqrJJknR9NLhH/wGuVDNC?=
 =?us-ascii?Q?RvmS5PcHK9JGoK+U6XHXROD2rhDg7UlyTo62lETYRuOJ5++bezKoRc2af7fL?=
 =?us-ascii?Q?TXXiDViTZp/Ks1RdNTO//obfWiq37bRPy127AvNK7b77B/9UFmEjA6ExNcfB?=
 =?us-ascii?Q?yggpJ7TLJ4/VLLQywti6tI2rZClfzjhhnoDW3yHcRGWS2F3GBhxIFQ7AmhdQ?=
 =?us-ascii?Q?gbT5kopTz/Rf4MfXyyS+l3lR2vHekcwkWmY4/E3yaGTEA0ZLQ5ufssC5GxSB?=
 =?us-ascii?Q?nHMjgnP3XiDXJYUyerQjPVZDV4UeheVrUSheJsmaBoes+bRcq9vTyaSvVlvf?=
 =?us-ascii?Q?hXHJvM4efxXmMmRzpxR9v9G7dW4lJbgrNuHZXnIEKmTmSOI6bW1mWDGJS2dV?=
 =?us-ascii?Q?qeeNtG/gwmtPbpCWn4uCgHVTLMO/DMyITr9mPWlI?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e954f5-4622-43a8-a32e-08dc0d0c396b
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4045.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 10:02:13.5532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nklCF+exo1OSu+7mZl3yOtgczEZDyuEB0R5DCzl9KHxHpYnBxCvD7IbtH5Uv/uqSNDmAlfXDI3ie+mYQr9Q1rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6841

When the system memory is low, kswapd reclaims the memory. The key steps
of memory reclamation include
1.shrink_lruvec
  * shrink_active_list, moves folios from the active LRU to the inactive LRU
  * shrink_inactive_list, shrink lru from inactive LRU list
2.shrink_slab
  * shrinker->count_objects(), calculates the freeable memory
  * shrinker->scan_objects(), reclaims the slab memory

The existing tracers in the vmscan are as follows:

--do_try_to_free_pages
--shrink_zones
--trace_mm_vmscan_node_reclaim_begin (tracer)
--shrink_node
--shrink_node_memcgs
  --trace_mm_vmscan_memcg_shrink_begin (tracer)
  --shrink_lruvec
    --shrink_list
      --shrink_active_list
	  --trace_mm_vmscan_lru_shrink_active (tracer)
      --shrink_inactive_list
	  --trace_mm_vmscan_lru_shrink_inactive (tracer)
    --shrink_active_list
  --shrink_slab
    --do_shrink_slab
    --shrinker->count_objects()
    --trace_mm_shrink_slab_start (tracer)
    --shrinker->scan_objects()
    --trace_mm_shrink_slab_end (tracer)
  --trace_mm_vmscan_memcg_shrink_end (tracer)
--trace_mm_vmscan_node_reclaim_end (tracer)

If we get the duration and quantity of shrink lru and slab,
then we can measure the memory recycling, as follows

Measuring memory reclamation with bpf:
  LRU FILE:
	CPU COMM 	ShrinkActive(us) ShrinkInactive(us)  Reclaim(page)
	7   kswapd0	 	26		51		32
	7   kswapd0		52		47		13
  SLAB:
	CPU COMM 		OBJ_NAME		Count_Dur(us) Freeable(page) Scan_Dur(us) Reclaim(page)
	 1  kswapd0		super_cache_scan.cfi_jt     2		    341		   3225		128
	 7  kswapd0		super_cache_scan.cfi_jt     0		    2247	   8524		1024
	 7  kswapd0	        super_cache_scan.cfi_jt     2367	    0		   0		0

For this, add the new tracer to shrink_active_list/shrink_inactive_list
and shrinker->count_objects().

Changes:
v5: * Use 'DECLARE_EVENT_CLASS(mm_vmscan_lru_shrink_start_template' to
replace 'RACE_EVENT(mm_vmscan_lru_shrink_inactive/active_start'
    * Add the explanation for adding new shrink lru events into 'mm: vmscan: add new event to trace shrink lru'
v4: Add Reviewed-by and Changlog to every patch.
v3: Swap the positions of 'nid' and 'freeable' to prevent the hole in the trace event.
v2: Modify trace_mm_vmscan_lru_shrink_inactive() in evict_folios() at the same time to fix build error.

cuibixuan (2):
  mm: shrinker: add new event to trace shrink count
  mm: vmscan: add new event to trace shrink lru

 include/trace/events/vmscan.h | 80 ++++++++++++++++++++++++++++++++++-
 mm/shrinker.c                 |  4 ++
 mm/vmscan.c                   | 11 +++--
 3 files changed, 90 insertions(+), 5 deletions(-)

-- 
2.17.1

