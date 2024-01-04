Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2092.outbound.protection.outlook.com [40.107.117.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06A720B02
	for <mm-commits@vger.kernel.org>; Thu,  4 Jan 2024 10:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="LlLS90tp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2ok6OIXXsojowSbTgN2WdsTUTj9uLlL2+fzaDcvufUYxUG0LgVJ3LxMbui4kPOsGIFoZr/hDn/hEZiylylXJ8IZ6YtAnVvQnrib7hRQnlDD+RokaX/c63CTF9oE3uvPKcthAZTwjVSExsB2VxcmMO1DcbiedW949kn0aoApZwTK7WCWwO7vx7keLVcQZrOPaMNLKPNescjAJX8WRehbfZWWHbUbh/g1QihEPw1PieCM4NglC6PVBz4eYjXepWEE009/G0sw0GnfFKIsQmRPVIwCwgeCbmEG6hhrAQqbOFSHP57SAKpMVPO3AvMPP+7rfDxyMNsvxGfa4GEjmV0blQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IyphLw1z3cXak/6N1bG1g+lJjhfGiAfu9pfQ+cF3bs=;
 b=Vjp0WykYbiPT07IfLXeEfveF1yWa1yQeg5Dq1iZaQOLawEqJH9z9/9H54zHZ5Ir46+j/b4Oy0JTKzYrYs5cQVN4/Phyfmg88v1x/Us9t3UF9l6JWoH6a6s8foI8hnGbLhpJ9A/QZtMTfJqJd1GVIlmHR4L0bAxg5QqFexk5Oxu79yZI9mWT/JxZcH7xReoFrJ7bj6SyDTgRqNz0p6p5m8KSTEEa4c9sKcVjtIiynpAX7fYIO8eL6b+DVJcNA7pIVCNCH8oBW1aRpZRQRDTIoV1rmI8/DUFRYmFXOeNwqPswsVEod7TKk6n2J8A1FdiKjpvvSn9B86kHjChXG/ssjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IyphLw1z3cXak/6N1bG1g+lJjhfGiAfu9pfQ+cF3bs=;
 b=LlLS90tp40R9b7jBADCHMSMLrEciARWN/+0PYuOKKcD/eNf8IsQE01emw6rQzjpI1eEGJ/8+wAhz1EZ6nLTAZzUYVa3WsaYowiVbHPZQCsy72ri+LIDTRYkp6ATwpdm1os83wwMSIf/QuJbq8rz25M0PLb/RvXPB02zcfiU12VAzHSf7uHR42Vq1IZGUR7EkIQ7mYqac2tK/UAPGiXg6XzyFdunAYfyQwOVFUe8X0fXz9IznyHJv02V08EIqMe9F8vTeNrBOitbfuqyCulO2ouAv61OsqCiSah1xUGfepkwk8xaSIii5TQtzsblJYfDZE2arQARjHD1c1aedtR4biQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com (2603:1096:400:21::8)
 by KL1PR0601MB4050.apcprd06.prod.outlook.com (2603:1096:820:2a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.14; Thu, 4 Jan
 2024 10:02:18 +0000
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5]) by TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5%7]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 10:02:17 +0000
From: Bixuan Cui <cuibixuan@vivo.com>
To: akpm@linux-foundation.org,
	mm-commits@vger.kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com
Cc: opensource.kernel@vivo.com,
	cuibixuan@vivo.com
Subject: [PATCH -next v5 1/2] mm: shrinker: add new event to trace shrink count
Date: Thu,  4 Jan 2024 02:01:44 -0800
Message-Id: <20240104100145.3855-2-cuibixuan@vivo.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240104100145.3855-1-cuibixuan@vivo.com>
References: <20240104100145.3855-1-cuibixuan@vivo.com>
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
X-MS-TrafficTypeDiagnostic: TYZPR06MB4045:EE_|KL1PR0601MB4050:EE_
X-MS-Office365-Filtering-Correlation-Id: 41d0632f-c6a8-4390-da6f-08dc0d0c3c04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hH7VUfzbxHsRQYiHkyJL1lz4ORsIVMq6oi4PXyKhZd4hlkzGwuP6Jv0X4InjnhcKTz2zYwLI0iRbyheUQSzepRycM54JgYmUq4R1Llo6ZVgBndiQuWnlt7ioVlOOVrJwyi2S25wb+jathyYwLnO2FY5IYlycVj7TpNNbaayop2FsIKSV8tfKuFDjEGhrUmrZ6+yXz97uXrK1imO7Caji5BW2uvA2JT0ADbUWfA6bDQMo1dO7pUyyQHEGJbWxFOgVAV9Hod6tPUMUuYhFRQrBJEUmYLqWbPO2Qh8olwwErbqZzzUVUE/JGhhNVxvWz0tghCGetU8YCgHCCst7s/9iLlxamC4faTNgHHk2IpK2YmiMoxMjFZtZaWskEe3LEi1gyl5Gad3R9sHTjlX0r0LRDT9mdvdl1ykHUwBZmapaXpCXxoHOktnOre1aRqHRz+wPgRUzvESr+ddoyN5OQiD0Fe2+KyAlUJW/Y/BwLL0txnMvUZY1HUcMzcvfst9J5Pf7CNpYAGgaXKoKe0EA/h0hzLkoIHPxS6yH+o8AItwitzushsbfEFbew9SPcySrwpj0rQP1eaqkJzq1oAoaU6a1pb9n23FFAItjzhkDS9e+1NIjlbdvs1gOJbRwOT5kc9bK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4045.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(366004)(396003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(40140700001)(5660300002)(38100700002)(86362001)(41300700001)(1076003)(6486002)(26005)(2616005)(107886003)(83380400001)(36756003)(52116002)(2906002)(478600001)(6512007)(38350700005)(6506007)(6666004)(4326008)(8676002)(8936002)(316002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R8Ha++pWFbUl5Ym5UvfeL4euhaUFsmjE9iicFK6rQHyYRPhvbjSlJW3V8/Dn?=
 =?us-ascii?Q?c60P/hpnnXOFzgusLudFEBf/sSBZ22ElUIg6bjUyTFJmao7KEQoWZ8en+cMz?=
 =?us-ascii?Q?bQ9IJSX4mm/7tVYfsaFI0dfncVsvu5NqPelwToXtWud68Fooa19S13u3mr2P?=
 =?us-ascii?Q?M44wRWTAssIV31Ry+lFslYTJ5io5bsDxDRf3uNmhlCoX5CAqTACk1EoGDyJG?=
 =?us-ascii?Q?BhcdOLL5fPYpiw2JvLAUCo4KBbEc241CPhlWYjcN0IlLqpLdcurjoqa02683?=
 =?us-ascii?Q?UcDL5AnVyHoWfsNcBbH+COET9mPcVEt6jcUv2jSibUM8G6Xh/1JtGy/n8Vru?=
 =?us-ascii?Q?5rKWSYzYd7rStGeFOr5KaHhMfdRE5m19YwbeXvCVuZGiXSoT+VjAH9CCPD0i?=
 =?us-ascii?Q?IfJqxn/3Q7ZVO21R5mUQB2qZaSkw4dF/rpROcfq+wif6xXwgww+5gsTZ6ZHa?=
 =?us-ascii?Q?CON0zTK86unYr0hk1uxl7tjVdXVedwkNUtDj/qSLatwlK2Wp/g7bEFnlFgVu?=
 =?us-ascii?Q?iJlfGKU79S/R+/Crzc00lRdsKrfAmHteIu7ueEnf457sMn8TSAFQXOksZvij?=
 =?us-ascii?Q?ZHNfjYJaQou4o2kvIy19gb6UFUqIi+Kj9YKX5IG2MtgoeYBaI97QGu2MWZY9?=
 =?us-ascii?Q?Y4pz05DADRJO2DzC6Cc4THt//NBkS3nf22vLCN8V/ZccdnEOqkMqzyTxoxPP?=
 =?us-ascii?Q?zcRvJ15e+KOdLGRqqJxxCmW/YHV9BKMxidraoK8MBbLBVhCJIEcNfiV0J5o7?=
 =?us-ascii?Q?Xbcej3fGZKVLp6U9x6XgWRbugmP3bgfUs8SQrplgjfCeRn1snkEtsDB94MiK?=
 =?us-ascii?Q?yZdXqeEiwUJDQqwbDBmU6J4j4eX35e277ya+MwpeQvg/Gn2q/6YVZCXkyXUU?=
 =?us-ascii?Q?ORfiNlCrHgZ+T5c8cdlOkVfrTzLj0Ld3rrwBvmS/HC1RCCjVYJM2peFm+uP7?=
 =?us-ascii?Q?KFZVUHiS4PXHyBP3/EmYfFz5mUpU/jobcYFzCMzttl453jLXXS4og51acNuC?=
 =?us-ascii?Q?Br3t9S6msXGxO9Xjh4V0MxYd/PIuhxu8JIzf3T142VI8k2C+dsfAq11LGkMe?=
 =?us-ascii?Q?qWf3JHUX5YcZWf2UkgWPGPvfRlfnz1K1jfTzts4FlmWXMOh1JDUzT4otctHh?=
 =?us-ascii?Q?1HE+hAnwxYQv1SKOUuKu3v5TEk0H92LJX1NlsDHlctOgVgJLxsg9Uh3rbHvH?=
 =?us-ascii?Q?hSndPWMhXcy/dgHeKvX3nhVOK5guI5dRuTVC9GM0IFUy4lWzDcazz6EJx9yA?=
 =?us-ascii?Q?qcsLxyv8pUq51UXiwrDoGBcGtl8gqgjrAqC7rgZlk4JtoJFuy9ak6V3Fva+j?=
 =?us-ascii?Q?/7oytHzLZ7EZMKqUJtPgY2MlpHDCxcTG07mGJHq+rCEThkzalvYA+tz2QwJA?=
 =?us-ascii?Q?1s3v7u/PYrhEyqIpGdOblhJDB+naq+V5t7fzilw/UR/Y82kyN7Jl25JjnyB5?=
 =?us-ascii?Q?DeiXRtJRJWxLRZk/16cLPKZH3SpRvRoL//CL4GhCH7gbtMrkja8g0MYQg6Dx?=
 =?us-ascii?Q?6ystw2wuGbg12EcDT56shyGjyjd15KqK6rUP7oVwCCXVdissJvi2bUs8tCec?=
 =?us-ascii?Q?PCq8za6mnoIr/xKr+h4gZUjRIxpqrPJjn8nU/Dcs?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d0632f-c6a8-4390-da6f-08dc0d0c3c04
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4045.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 10:02:17.8763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnQ2VzrcyMccC/I1OVhp7H8Ny6WO8OLaMPNNdsHzwZQ/6vGoHRNv9can4UewyOKSW7XASYhp5djuweFS/3Nn2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4050

From: cuibixuan <cuibixuan@vivo.com>

do_shrink_slab() calculates the freeable memory through shrinker->count_objects(),
and then reclaims the memory through shrinker->scan_objects(). When reclaiming
memory, shrinker->count_objects() takes a certain amount of time:

	Fun               spend(us)
	ext4_es_count     4302
	ext4_es_scan      12
	super_cache_count 4195
	super_cache_scan  2103

Therefore, adding the trace event to count_objects() can more accurately
obtain the time taken for slab memory recycling.

Example of output:
         kswapd0-103     [003] .....  1098.317942: mm_shrink_count_start: kfree_rcu_shrink_count.cfi_jt+0x0/0x8 00000000c540ff51: nid: 0
         kswapd0-103     [003] .....  1098.317951: mm_shrink_count_end: kfree_rcu_shrink_count.cfi_jt+0x0/0x8 00000000c540ff51: nid: 0 freeable:36

Signed-off-by: Bixuan Cui <cuibixuan@vivo.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---
Changes:
v5: * Use 'DECLARE_EVENT_CLASS(mm_vmscan_lru_shrink_start_template' to
replace 'RACE_EVENT(mm_vmscan_lru_shrink_inactive/active_start'
    * Add the explanation for adding new shrink lru events into 'mm: vmscan: add new event to trace shrink lru'
v4: * Add Reviewed-by and Changlog to every patch.
v3: * Swap the positions of 'nid' and 'freeable' to prevent the hole in the trace event.
v2: * Modify trace_mm_vmscan_lru_shrink_inactive() in evict_folios() at the same time to fix build error (Andrew pointed out).

 include/trace/events/vmscan.h | 49 +++++++++++++++++++++++++++++++++++
 mm/shrinker.c                 |  4 +++
 2 files changed, 53 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 1a488c30afa5..b99cd28c9815 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -196,6 +196,55 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_re
 );
 #endif /* CONFIG_MEMCG */
 
+TRACE_EVENT(mm_shrink_count_start,
+	TP_PROTO(struct shrinker *shr, struct shrink_control *sc),
+
+	TP_ARGS(shr, sc),
+
+	TP_STRUCT__entry(
+		__field(struct shrinker *, shr)
+		__field(void *, shrink)
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->shr = shr;
+		__entry->shrink = shr->count_objects;
+		__entry->nid = sc->nid;
+	),
+
+	TP_printk("%pS %p: nid: %d",
+		__entry->shrink,
+		__entry->shr,
+		__entry->nid)
+);
+
+TRACE_EVENT(mm_shrink_count_end,
+	TP_PROTO(struct shrinker *shr, struct shrink_control *sc, long freeable),
+
+	TP_ARGS(shr, sc, freeable),
+
+	TP_STRUCT__entry(
+		__field(struct shrinker *, shr)
+		__field(void *, shrink)
+		__field(long, freeable)
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->shr = shr;
+		__entry->shrink = shr->count_objects;
+		__entry->freeable = freeable;
+		__entry->nid = sc->nid;
+	),
+
+	TP_printk("%pS %p: nid: %d freeable:%ld",
+		__entry->shrink,
+		__entry->shr,
+		__entry->nid,
+		__entry->freeable)
+);
+
 TRACE_EVENT(mm_shrink_slab_start,
 	TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
 		long nr_objects_to_shrink, unsigned long cache_items,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index dd91eab43ed3..d0c7bf61db61 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -379,7 +379,11 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 					  : SHRINK_BATCH;
 	long scanned = 0, next_deferred;
 
+	trace_mm_shrink_count_start(shrinker, shrinkctl);
+
 	freeable = shrinker->count_objects(shrinker, shrinkctl);
+
+	trace_mm_shrink_count_end(shrinker, shrinkctl, freeable);
 	if (freeable == 0 || freeable == SHRINK_EMPTY)
 		return freeable;
 
-- 
2.17.1

